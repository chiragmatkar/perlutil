    #!/usr/bin/perl -w -T

    use strict;
    use WWW::Mechanize;

    my $login    = "login_name";
    my $password = "password";
    my $folder   = "folder";

    my $url = "http://img78.photobucket.com/albums/v281/$login/$folder/";

    # login to your photobucket.com account
    my $mech = WWW::Mechanize->new();
    $mech->get($url);
    $mech->submit_form(
        form_number => 1,
        fields      => { password => $password },
    );
    die unless ($mech->success);

    # upload image files specified on command line
    foreach (@ARGV) {
        print "$_\n";
        $mech->form_number(2);
        $mech->field('the_file[]' => $_);
        $mech->submit();
    }
