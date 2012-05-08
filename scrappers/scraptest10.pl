    use strict;
    use WWW::Mechanize;

    # a tool to automatically post entries to a moveable type weblog, and set arbitrary creation dates

    my $mech = WWW::Mechanize->new();
    my $entry;
    $entry->{title} = "Test AutoEntry Title";
    $entry->{btext} = "Test AutoEntry Body";
    $entry->{date} = '2002-04-15 14:18:00';
    my $start = qq|http://my.blog.site/mt.cgi|;

    $mech->get($start);
    $mech->field('username','und3f1n3d');
    $mech->field('password','obscur3d');
    $mech->submit(); # to get login cookie
    $mech->get(qq|$start?__mode=view&_type=entry&blog_id=1|);
    $mech->form_name('entry_form');
    $mech->field('title',$entry->{title});
    $mech->field('category_id',1); # adjust as needed
    $mech->field('text',$entry->{btext});
    $mech->field('status',2); # publish, or 1 = draft
    $results = $mech->submit();

    # if we're ok with this entry being datestamped "NOW" (no {date} in %entry)
    # we're done. Otherwise, time to be tricksy
    # MT returns a 302 redirect from this form. the redirect itself contains a <body onload=""> handler
    # which takes the user to an editable version of the form where the create date can be edited       
    # MT date format of YYYY-MM-DD HH:MI:SS is the only one that won't error out

    if ($entry->{date} && $entry->{date} =~ /^\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}/) {
        # travel the redirect
        $results = $mech->get($results->{_headers}->{location});
        $results->{_content} =~ /<body onLoad="([^\"]+)"/is;
        my $js = $1;
        $js =~ /\'([^']+)\'/;
        $results = $mech->get($start.$1);
        $mech->form_name('entry_form');
        $mech->field('created_on_manual',$entry->{date});
        $mech->submit();
    }
