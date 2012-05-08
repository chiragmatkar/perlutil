use Test::More qw(no_plan);
use strict;
use warnings 'all';
use lib qw(/mypath/);

use Lib::Constants;

use WWW::Mechanize;

use constant	USERNAME	=>	'user';
use constant	PASSWORD	=>	'pass';

# ==========================================================================
# Test logging in and out. We suppress warnings as we expect to NOT see 
# the login form when logged in.
# ==========================================================================

my $mech = WWW::Mechanize->new(
	quiet	=>	1
);

my $base = '';
if(Constants::APPSTATUS < 0)
{
	$base = Constants::DEVURL;
}
else
{
	$base = Constants::UATURL;
}

$mech->get( $base . 'index.cgi' );
ok($mech->success(), "Home page loaded successfully");

# We are not logged in, we should have a login option.
cmp_ok($mech->form_name('login'), '!=', undef, "Login form loaded sucessfully");

# Login
$mech->form_number('1');
$mech->field('USERNAME', USERNAME);
$mech->field('PASSWORD', PASSWORD);
$mech->submit();

ok($mech->success(), "Login details submitted successfully");

# We should now be able to load the home page without
# seeing the login form
$mech->get( $base . 'index.cgi?rm=home' );
ok($mech->success(), "Home page loaded successfully after sending in log in details");

# If we have a logout option then we logged in ok!
cmp_ok($mech->form_name('login'), '==', undef, "Logged in correctly. Page no longer shows logout option.");

# Now logout - this redirects to the home via a meta refresh.
$mech->get( $base . 'index.cgi?rm=logout' );
ok($mech->success(), "Logout call made successfully");

# Try and view the home page again
$mech->get( $base . 'index.cgi?rm=home' );
ok($mech->success(), "Home page reloaded successfully");
cmp_ok($mech->form_name('login'), '!=', undef, "Login form sucessfully shown again");

