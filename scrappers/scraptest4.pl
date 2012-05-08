    #!/arch/unix/bin/perl
    use strict;
    use warnings;
    #
    # listmod - fast alternative to mailman list interface
    #
    # usage: listmod crew XXXXXXXX
    #

    die "usage: $0 <listname> <password>\n" unless @ARGV == 2;
    my ($listname, $password) = @ARGV;

    use CGI qw(unescape);

    use WWW::Mechanize;
    my $m = WWW::Mechanize->new( autocheck => 1 );

    use Term::ReadLine;
    my $term = Term::ReadLine->new($0);

    # submit the form, get the cookie, go to the list admin page
    $m->get("https://lists.ccs.neu.edu/bin/admindb/$listname");
    $m->set_visible( $password );
    $m->click;

    # exit if nothing to do
    print "There are no pending requests.\n" and exit
        if $m->content =~ /There are no pending requests/;

    # select the first form and examine its contents
    $m->form_number(1);
    my $f = $m->current_form or die "Couldn't get first form!\n";

    # get me the base form element for each email item
    my @items = map {m/^.+?-(.+)/} grep {m/senderbanp/} $f->param
        or die "Couldn't get items in first form!\n";

    # iterate through items, prompt user, commit actions
    foreach my $item (@items) {

        # show item info
        my $sender = unescape($item);
        my ($subject) = [$f->find_input("senderbanp-$item")->value_names]->[1] 
            =~ /Subject:\s+(.+?)\s+Size:/g;

        # prompt user
        my $choice = '';
        while ( $choice !~ /^[DAX]$/ ) {
            print "$sender\: '$subject'\n";
            $choice = uc $term->readline("Action: defer/accept/discard [dax]: ");
            print "\n\n";
        }

        # set button
        $m->field("senderaction-$item" => {D=>0,A=>1,X=>3}->{$choice});
            }

    # submit actions
    $m->click;
