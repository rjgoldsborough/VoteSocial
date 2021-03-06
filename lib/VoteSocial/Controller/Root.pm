package VoteSocial::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

VoteSocial::Controller::Root - Root Controller for VoteSocial

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->stash(
  	content => $c->model('Representatives::GoogleCivicInfo')->fetch(
  	  $c->req->param('address')
  	),
  	version => $VoteSocial::VERSION,
  	debug   => $c->req->param('debug'),
  );

  $Template::Stash::HASH_OPS->{ sort_by_division_id_length } = sub {
    my ($hash) = @_;
	return sort {
	  length($a) <=> length($b)
	} keys %$hash
  };
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Jay Hannah

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
