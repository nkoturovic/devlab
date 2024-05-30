module kotur.me/devlab/modules

require "kotur.me/devlab/modules/module1" v0.0.0
replace "kotur.me/devlab/modules/module1" v0.0.0 => "./module1"

require "kotur.me/devlab/modules/module2" v0.0.0
replace "kotur.me/devlab/modules/module2" v0.0.0 => "./module2"

go 1.22.3
