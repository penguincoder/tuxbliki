Merb.logger.info("Compiling routes...")
Merb::Router.prepare do |r|
  r.match('/node/node/:id').to(
    :controller => 'node',
    :action => 'show'
  )
  r.match('/node/:id').to(
    :controller => 'node',
    :action => 'show'
  )
  r.match('/horde/chora/:phpaction.php/:program').to(
    :controller => 'node',
    :action => 'chora'
  )
  r.resources :pages
  r.resources :comments
  r.resources :tags
  r.match('/tags/auto_complete').to(
    :controller => 'tags',
    :action => 'auto_complete'
  )
  r.resources :authors
  r.resources :sessions
  r.resources :permissions
  r.resources :news
  r.resources :invitations
  r.resources :albums
  r.resources :photos
  r.match('/photos/thumbnail/:id').to(
    :controller => 'photos',
    :action => 'thumbnail'
  )
  r.match('/photos/screen/:id').to(
    :controller => 'photos',
    :action => 'screen'
  )
  r.match('/photos/set_album_thumbnail/:id').to(
    :controller => 'photos',
    :action => 'set_album_thumbnail'
  )
  r.resources :photo_tags
  r.match('/').to(
    :controller => 'news',
    :action => 'index'
  )
end
