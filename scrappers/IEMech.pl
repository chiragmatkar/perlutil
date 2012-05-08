    use Win32::IE::Mechanize;

    my $ie = Win32::IE::Mechanize->new( visible => 1 );

    $ie->get( $url );

    $ie->follow_link( text => $link_txt );

    $ie->form_name( $form_name );
    $ie->set_fields(
        username => 'yourname',
        password => 'dummy' 
    );
    $ie->click( $btn_name );

    # Or all in one go:
    $ie->submit_form(
        form_name => $form_name,
        fields    => {
            username => 'yourname',
            password => 'dummy',
        },
        button    => $btn_name,
    );