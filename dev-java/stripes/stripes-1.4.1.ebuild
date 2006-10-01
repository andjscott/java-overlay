# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 versionator


DESCRIPTION="A java presentation framework for building web applications"
HOMEPAGE="http://stripes.mc4j.org/confluence/display/stripes/Home"
SRC_URI="mirror://sourceforge/stripes/${P}-src.zip"

LICENSE=""
SLOT="1.4"
KEYWORDS="~amd64"
IUSE="doc source"

CDEPEND=">=dev-java/commons-logging-1.0.4
		dev-java/cos
		=dev-java/servletapi-2.4*"

DEPEND=">=virtual/jdk-1.5
		app-arch/unzip
		>=dev-java/ant-core-1.5*
		doc? ( dev-java/taglibrarydoc
		dev-java/sun-javamail-bin )
		${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
		${CDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	cd ${PN}/lib/build
	rm *.jar

	#add new jars to file
	java-pkg_jarfrom servletapi-2.4	
	java-pkg_jarfrom cos
	use doc && java-pkg_jarfrom taglibrarydoc
	use doc && java-pkg_jarfrom sun-javamail-bin mail.jar
}

src_compile() {
	eant build $(use_doc doc)
}

src_install() {
	cd stripes
	java-pkg_dojar dist/*.jar

	use doc && java-pkg_dohtml -r docs/api docs/taglib
	use source && java-pkg_dosrc src/*
}