FROM alpine:latest
ARG RT_VERSION=5.0.2

ENV RT_DB_HOST=rt5
ENV RT_DB_PORT=3306
ENV RT_DB_USER=rt5
ENV RT_DB_NAME=rt5
ENV RT_DB_PASSWORD=secret
ENV RT_WEB_DOMAIN=localhost
ENV RT_VERSION=$RT_VERSION

RUN wget https://download.bestpractical.com/pub/rt/release/rt-${RT_VERSION}.tar.gz && tar xfz rt-${RT_VERSION}.tar.gz

RUN apk add --no-cache perl perl-dev gettext perl-app-cpanminus perl-module-build perl-apache-session perl-business-hours \
    perl-json perl-cgi perl-cgi-psgi perl-dbi perl-dbix-searchbuilder perl-data-ical perl-file-which perl-crypt-x509 perl-string-shellquote \
    perl-dbd-mysql perl-graphviz perl-ipc-run perl-gd perl-gdgraph perl-gdtextutil perl-fcgi perl-cgi-emulate-psgi \
    perl-css-minifier-xs perl-css-squish perl-convert-color perl-crypt-eksblowfish perl-data-guid perl-data-page-pageset \
    perl-date-extract perl-date-manip perl-datetime perl-devel-globaldestruction perl-email-address \
    perl-email-address-list perl-encode-hanextra perl-term-readkey perl-text-password-pronounceable  perl-text-quoted \
    perl-text-template perl-text-wikiformat perl-text-wrapper perl-time-parsedate perl-tree-simple perl-universal-require \
    perl-xml-rss perl-html-mason perl-html-mason-psgihandler \
    perl-moose perl-mozilla-ca perl-regexp-common \
    perl-html-quoted perl-html-rewriteattributes perl-html-scrubber perl-locale-maketext-fuzzy \
    perl-locale-maketext-lexicon perl-log-dispatch perl-mime-types perl-mime-tools \
    perl-javascript-minifier-xs perl-regexp-common-net-cidr perl-regexp-ipv6 \
    perl-module-refresh \
    perl-module-versions-report \
    perl-html-formattext-withlinks perl-html-formattext-withlinks-andtables \
    perl-plack perl-starlet perl-scope-upper perl-symbol-global-name perl-role-basic \
    perl-parallel-forkmanager perl-lwp-protocol-https perl-net-cidr perl-net-ip \
    git expat-dev gd-dev gnupg libressl-dev  \
    zlib-dev graphviz build-base gcc autoconf

RUN cd rt-${RT_VERSION} && \
    ./configure \
    --enable-gd \
    --enable-gpg \
    --enable-smime && \
    cpanm --notest --no-wget Encode::Detect::Detector HTML::FormatExternal HTML::Gumbo Module::Path MooseX::NonMoose MooseX::Role::Parameterized Path::Dispatcher Text::WordDiff Web::Machine GnuPG::Interface PerlIO::eol && \
    rm -fr root/.cpanm; exit 0 && \
    make fixdeps install RT_FIX_DEPS_CMD='cpanm --no-wget'
RUN apk del build-base gcc autoconf perl-dev perl-app-cpanminus perl-module-build expat-dev zlib-dev libressl-dev gd-dev libc-dev g++