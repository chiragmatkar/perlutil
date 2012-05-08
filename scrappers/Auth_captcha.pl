use Authen::Captcha;

# create a new object
my $captcha = Authen::Captcha->new();

# set the data_folder. contains flatfile db to maintain state
$captcha->data_folder('/some/folder');

# set directory to hold publicly accessable images
$captcha->output_folder('/some/http/folder');

# Alternitively, any of the methods to set variables may also be
# used directly in the constructor

my $captcha = Authen::Captcha->new(
    data_folder => '/some/folder',
    output_folder => '/some/http/folder',
);

# create a captcha. Image filename is "$md5sum.png"
my $md5sum = $captcha->generate_code($number_of_characters);

# check for a valid submitted captcha
#   $code is the submitted letter combination guess from the user
#   $md5sum is the submitted md5sum from the user (that we gave them)
my $results = $captcha->check_code($code,$md5sum);
  # $results will be one of:
  #          1 : Passed
  #          0 : Code not checked (file error)
  #         -1 : Failed: code expired
  #         -2 : Failed: invalid code (not in database)
  #         -3 : Failed: invalid code (code does not match crypt)
  ##############