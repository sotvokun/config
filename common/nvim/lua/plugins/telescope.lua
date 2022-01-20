local tp = require('telescope')

tp.setup {
    extensions = {
        file_browser = {}
    }
}

tp.load_extension "file_browser"
