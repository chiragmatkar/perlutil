package FileOperations;


sub read_file{
	my ($filename)=shift;
	open(FH,$filename) or die "cannot read file";
	my $filebuffer= join "" , <FH>;
	close(FH);
	return $filebuffer;
}


sub write_file{
	my ($data,$outfile)=@_;
	open(FH,">$outfile") or die "cannot create new file";
	print FH $data;
	close(FH);
}


sub append_file{
	my ($data,$outfile)=@_;
	open(FH,">>$outfile") or die "cannot append new file";
	print FH $data;
	close(FH);
}







1