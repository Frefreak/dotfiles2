function kr --wraps=okular --description 'alias kr okular'
  okular $argv &
  disown $last_pid
end
