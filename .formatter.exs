[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  import_deps: [:ecto, :phoenix],
  locals_without_parens: [defenum: 2]
]
