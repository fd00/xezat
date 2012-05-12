
module Yacptool

  class IllegalArgumentOfMainException < Exception
    # シェル引数が不正であった場合に投げられる
  end

  class IllegalArgumentOfCommandException < Exception
    # コマンド引数が不正であった場合に投げられる
  end
  
  class UnoverwritableCygportException < Exception
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

  class NoSuchCygclassException < Exception
    # .cygclass が存在しない場合に投げられる
  end
  
  class CygclassConflictException < Exception
    # 複数の vcs cygclass が指定された場合に投げられる
  end

end
