    #!/usr/bin/perl

    # Provides an rss feed of a paid user's LiveJournal friends list
    # Full entries, protected entries, etc.
    # Add to your favorite rss reader as
    # http://your.site.com/cgi-bin/lj_friends.cgi?user=USER&password=PASSWORD

    use warnings;
    use strict;

    use WWW::Mechanize;
    use CGI;

    my $cgi = CGI->new();
    my $form = $cgi->Vars;

    my $agent = WWW::Mechanize->new();

    $agent->get('http://www.livejournal.com/login.bml');
    $agent->form_number('3');
    $agent->field('user',$form->{user});
    $agent->field('password',$form->{password});
    $agent->submit();
    $agent->get('http://www.livejournal.com/customview.cgi?user='.$form->{user}.'&styleid=225596&checkcookies=1');
    print "Content-type: text/plain\n\n";
    print $agent->content();
