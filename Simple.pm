# -*- cperl -*-
#
# Copyright (c) 1997-2002 Samuel MOUNIEE
#
#    This file is part of Log::Simple.
#
#    Log::Simple is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    Log::Simple is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Log::Simple ; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
package	Log::Simple;

use	strict;

no	strict	qw( refs );

use	vars qw( $VERSION @ISA @EXPORT @EXPORT_OK );

use	Exporter;

( $VERSION ) = '$Revision: 1.2 $ ' =~ /\$Revision:\s+([^\s]+)/;


@ISA		= qw( Exporter );
@EXPORT_OK	= qw( logger time_track set_logger set_local_logger );

my ( $LOGLEVEL, $CONFESS )	= ( 0, 0 );


my $LOGGER		= {
	Default => [ \&std_logger ]
};

=pod

=head1	NAME

Log::Simple - Basic runtime logger

=head1	SYNOPSIS

  use Log::Simple ( 1 );


  logger( 1, "toto" );

  logger( 2, "tata", $tutu, "kiki" );


=head1	DESCRIPTION

=head2	External Functions


=over	4

=item	logger

log informations

=cut
sub	logger {
  my	$cllpkg	= (caller(0))[0];

  my $i	=  $cllpkg . "::LOGLEVEL";

  $cllpkg = "Default"	unless	defined( $LOGGER->{$cllpkg} );

  if	( ( defined( ${$i} ) && ( $_[0] <= ${$i} ) ) ||
	  (!defined( ${$i} ) && ( $_[0] <= $LOGLEVEL ) ) ) {
	return	$LOGGER->{$cllpkg}->[$_[0]+1]->( @_ )
		if ref( $LOGGER->{$cllpkg}->[$_[0]+1] ) eq "CODE";

	return $LOGGER->{$cllpkg}->[0]->( @_ )
		if ref( $LOGGER->{$cllpkg}->[0] ) eq "CODE";

	return	stdlogger( @_ );
  }
  return -1;
}


=pod

=item	set_logger

install an generic Logger

=cut
sub	set_logger($&) {
  my( $level, $code ) = @_;

  $level	= -1	if $level < 0;

  $LOGGER->{Default}->[$level+1] = $code;
}


=pod

=item	set_local_logger

install an local Logger

=cut
sub	set_local_logger($&) {
  my( $level, $code ) = @_;

  my	$cllpkg	= (caller(0))[0];

  $level	= -1	if $level < 0;

  $LOGGER->{$cllpkg} = [ \&stdlogger ]
	unless	defined( $LOGGER->{$cllpkg} );

  $LOGGER->{$cllpkg}->[$level+1] = $code;
}


=pod

=back

=head2	Internal Functions

=over	4

=item	std_logger

log information to STDERR

=cut
sub	std_logger {
  my $l  = shift;
  print STDERR ( $l ) . " : " . join( " + ", @_, "\n" );
  return $l	unless $CONFESS;

  my ( $i, @tmp ) = ( 0 );

  while( @tmp = caller( $i++ ) ) {
	print STDERR "\t> " . join( " + ", grep { defined $_ } @tmp, "\n" );
  }

  return $l;
}


sub	time_track
{
  Log::Simple::std_logger( "time_track", time(), ( caller ) )
}


=pod

=item	import

Set the Logging/Debug level and export external functions

=cut
sub	import($$)
{
  my	@tmp	= @EXPORT_OK;
  my	$cllpkg	= (caller(0))[0];
  my	$DBG	= $cllpkg . "::LOGLEVEL";
  my	$dbg	= $cllpkg . "::logger";

  ${$DBG}	= $_[1];

  if	( $_[1] > 0 )
  {
  }
  else
  {
	shift	@tmp;
	*{$dbg} = sub { };
  }
  Log::Simple->export_to_level( 1, undef, @tmp );
}


__END__

=pod

=back

=head1	BUGS

=over	4

=item	*
I don't know ...

=back

=head1	TO DO

=over	4

=item	*
Better documentation

=item	*
Other functions

=item	*
Add tests ...

=back

=head1 COPYRIGHT, LICENCE

 Copyright (c) 1997-2002 Samuel MOUNIEE

This file is part of Log::Simple.

Log::Simple is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

Log::Simple is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Log::Simple ; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


=head1 AUTHOR

Samuel Mouniée aka Moun's, mouns@cpan.org

=head1 SEE ALSO

perl(1).

