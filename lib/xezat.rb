module Xezat
  ROOT_DIR = File::expand_path(File::join(File::dirname(__FILE__), '..'))
  DATA_DIR = File::expand_path(File::join(ROOT_DIR, 'share', 'xezat'))
  REPOSITORY_DIR = File::expand_path(File::join(DATA_DIR, 'repository'))
  TEMPLATE_DIR = File::expand_path(File::join(DATA_DIR, 'template'))
end
