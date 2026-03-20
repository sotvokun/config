case "$1" in
	upgrade)
	curl -o ./autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	;;

	*)
	echo "Usage: {upgrade}"
	;;
esac
