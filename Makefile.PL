# IMPORTANT: if you delete this file your app will not work as
# expected.  you have been warned
use inc::Module::Install;

name 'MoneyTraq';
all_from 'lib/MoneyTraq.pm';

requires 'Catalyst::Runtime' => '5.7015';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Plugin::DateTime';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::File';
requires 'Catalyst::Plugin::Authorization::ACL';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Plugin::StackTrace';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::View::TT';
requires 'Catalyst::Controller::HTML::FormFu';
requires 'Catalyst::Controller::BindLex';
requires 'Cwd';
requires 'DateTime::Format::SQLite';
requires 'parent';
requires 'Config::General';
requires 'DBIx::Class::Migration';
requires 'Catalyst::Action::REST' => '1.11';
requires 'Catalyst::Authentication::Credential::HTTP' => '1.015';
requires 'JSON' => '2.59';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
