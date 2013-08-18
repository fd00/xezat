
module Xezat

  # このツールのルートディレクトリ
  ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

  # このツールの使用するデータがあるディレクトリ
  DATA_DIR = File.expand_path(File.join(ROOT_DIR, 'share', 'xezat'))

  # patches のテンプレートパス
  PATCHES_TEMPLATE_DIR = File.expand_path(File.join(DATA_DIR, 'template', 'patches'))

  class IllegalArgumentException < Exception
    # メソッドへの引数が不正であった場合に投げられる
  end

  class IllegalStateException < Exception
    # 必要な cygport のコマンドが完了していない場合に投げられる
    # 例: cygport prep の前に xezat patches を起動した
  end

  class IllegalArgumentOfMainException < Exception
    # シェル引数が不正であった場合に投げられる
  end

  class IllegalArgumentOfCommandException < Exception
    # コマンド引数が不正であった場合に投げられる
  end
  
  class UnoverwritableConfigurationException < Exception
    # cygport が上書きオプションなしに上書きされそうな場合に投げられる
  end
  
  class NoSuchTemplateException < Exception
    # 存在しないテンプレートが指定された場合に投げられる
  end

  class MultipleCommandDefinitionException < Exception
    # コマンドが多重定義された場合に投げられる
  end

  class NoSuchCommandDefinitionException < Exception
    # 存在しないコマンドが指定された場合に投げられる
  end
  
  class MultipleDetectorDefinitionException < Exception
    # 検出器が多重定義された場合に投げられる
  end

  class NoSuchCygclassException < Exception
    # .cygclass が存在しない場合に投げられる
  end
  
  class CygclassConflictException < Exception
    # 複数の vcs cygclass が指定された場合に投げられる
  end

  class CygportProcessException < Exception
    # 外部 cygport プロセスがエラーの場合に投げられる
  end

end
