This script only handles cells on the first visit, resetting if the cell file was not present on server startup. That means, that only cell reset scripts that actually remove cell files will cause creatures to be re-duplicated. One such script is my own [CellReset](https://github.com/tes3mp-scripts/CellReset).
If you choose to use it, `require` DoubleTrouble after CellReset in `customScripts.lua` for them to interact properly.

You can find the configuration file in `server/data/custom/__config_DoubleTrouble.json`.
* `"copies"` how many copies of the same creature you want to have. The default value is `5`.
* `"creatures"` a list of all creatures' refIds that should be duplicated. This is largely arbitrary, feel free to change it.