# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xalan/xalan-2.7.0-r2.ebuild,v 1.5 2006/09/14 00:29:07 nichoj Exp $

inherit java-pkg-2 java-ant-2 eutils versionator

MY_PN="${PN}-j"
MY_PV="$(replace_all_version_separators _)"
MY_P="${MY_PN}_${MY_PV}"
DESCRIPTION="Apache's XSLT processor for transforming XML documents into HTML, text, or other XML document types."
HOMEPAGE="http://xml.apache.org/xalan-j/index.html"
SRC_URI="mirror://apache/xml/${MY_PN}/source/${MY_P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="doc source"
COMMON_DEP="
	dev-java/javacup
	dev-java/bcel
	>=dev-java/jakarta-regexp-1.3-r2
	=dev-java/bsf-2.3*
	>=dev-java/xerces-2.7.1
	=dev-java/xml-commons-external-1.3*
	~dev-java/xalan-serializer-${PV}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.5.2
	source? ( app-arch/zip )
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	#disable building of serializer.jar
	sed -i -e 's/depends="prepare,serializer.jar"/depends="prepare"/' \
		build.xml || die "sed build.xml failed"

	# remove bundled jars
	rm -f lib/*.jar tools/*.jar
	cd lib
	java-pkg_jar-from xml-commons-external-1.3 xml-apis.jar
	java-pkg_jar-from xerces-2 xercesImpl.jar
	java-pkg_jar-from javacup javacup.jar java_cup.jar
	java-pkg_jar-from javacup javacup.jar runtime.jar
	java-pkg_jar-from bcel bcel.jar BCEL.jar
	java-pkg_jar-from jakarta-regexp-1.3 jakarta-regexp.jar regexp.jar

	cd "${S}"
	mkdir build && cd build
	java-pkg_jar-from xalan-serializer serializer.jar
}

# When version bumping Xalan make sure that the installed jar
# does not bunled .class files from dependencies
src_compile() {
	eant jar $(use_doc javadocs -Dbuild.apidocs=build/docs/api) \
		-Dxsltc.bcel_jar.not_needed=true \
		-Dxsltc.runtime_jar.not_needed=true \
		-Dxsltc.regexp_jar.not_needed=true
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	# installs symlinks to the file in /usr/share/xalan-serializer
	java-pkg_dojar build/serializer.jar
	# and records it to package.env as if it belongs to this one's
	# classpath, for maximum possible backward compatibility
	java-pkg_regjar $(java-pkg_getjar xalan-serializer serializer.jar)
	
	java-pkg_dolauncher ${PN} --main org.apache.xalan.xslt.Process
	use doc && java-pkg_dojavadoc build/docs/api
	use source && java-pkg_dosrc src/org
}