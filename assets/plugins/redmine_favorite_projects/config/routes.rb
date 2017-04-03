match 'favorite_projects/:action',
      controller: :favorite_projects, via: [:get, :post, :put]
match 'favorite_projects/search',
      to: 'favorite_projects#search', as: 'search_favorite_projects', via: [:get, :put, :post]
