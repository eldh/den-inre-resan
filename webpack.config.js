var path = require('path');
var _ = require('lodash');
var webpack = require('webpack');
var RHLMatches = /--view|viewcomponents\//;
var CordovaPlugin = require('webpack-cordova-plugin');

var webpackCommon = {
	cache: true,
	node: {
		__filename: true
	},
	output: {
		path: path.join(__dirname, 'app/'),
		publicPath: '/',
		filename: '[name]-bundle.js',
		chunkFilename: '[chunkhash].js'
	},
	module: {
		loaders: [
			{ test: /\.woff$/, loader: 'url-loader?prefix=font/&limit=5000&mimetype=application/font-woff' },
			{ test: /\.ttf$|\.eot$/, loader: 'file-loader?prefix=font/' },
			{
				test: /\.coffee$/,
				exclude: RHLMatches,
				loader: 'jshint-loader!coffee-loader'
			},	// enable post compile jshint, rules/flags at the bottom
			{ test: /\.json$/, loader: 'json-loader' },
			{ test: /\.svg$/, loader: 'raw-loader' },
			{ test: /\.css$/, loaders: [
				'style-loader',
				'css-loader'
			]},
			{ test: /\.scss$/, loaders: [
				'style-loader',
				'css-loader',
				'autoprefixer-loader?{browsers:["last 2 version", "ie 10", "Android 4"]}',
				'sass-loader'
			]},
			{ test: RHLMatches, loader: 'react-hot!coffee-loader' },
			{ test: /js-breakpoints\/breakpoints\.js$/, loader: 'exports-loader?window.Breakpoints' }	// special loader for js-breakpoints since it's not a proper module
		]
	},
	resolve: {
		alias: {
			'Breakpoints': 'js-breakpoints/breakpoints',
			'polyfill-dataset': 'html5-polyfills/dataset',
			'underscore': 'lodash'
		},
		extensions: ['', '.webpack.js', '.web.js', '.js', '.coffee', '.json'],
		modulesDirectories: ['node_modules', 'scripts', 'app/bower_components', 'web_modules']
	},
	plugins: [
		new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en-gb|sv/)
	],
	jshint: {
		bitwise: false,
		boss: true,
		curly: false,
		eqnull: true,
		expr: true,
		newcap: false,
		quotmark: false,
		shadow: true,
		strict: false,
		sub: true,
		undef: true,
		unused: 'vars'
	}
};

module.exports = function(config) {
    return _.merge({}, webpackCommon, config, function(a, b) {
        return _.isArray(a) ? a.concat(b) : undefined;
    });
};
