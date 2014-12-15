ConfigFile = require '../../resources/app/config'
PrivateConfigFile = require '../../resources/common/private-config'
_ = require 'lodash'

module.exports = _.merge {}, ConfigFile, PrivateConfigFile
