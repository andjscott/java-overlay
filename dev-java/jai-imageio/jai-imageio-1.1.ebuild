# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"
inherit java-pkg-2 java-ant-2 cvs

ECVS_SERVER="cvs.dev.java.net:/cvs"
ECVS_MODULE="jai-imageio-core"
ECVS_USER="gentoo_linux"
ECVS_PASS="peerlesspenguin"
ECVS_BRANCH="jai-imageio-1_1-fcs"

DESCRIPTION="A library for managing images based on JAI"
HOMEPAGE="https://jai-imageio.dev.java.net/"
LICENSE="jai-imageio sun-bcla-jclib4jai"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/sun-jai-bin"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.4"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.4"

S="${WORKDIR}/${PN}-core"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="sun-jai-bin"
EANT_GENTOO_CLASSPATH_EXTRA="src/share/jclib4jai/clibwrapper_jiio.jar"

src_install() {
	dohtml www/index.html || die
	use source && java-pkg_dosrc src/share/classes/*

	cd build/*/opt/lib || die
	java-pkg_dojar ext/clibwrapper_jiio.jar ext/jai_imageio.jar
	java-pkg_doso */libclib_jiio.so
}
