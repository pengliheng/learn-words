import * as HtmlWebpackPlugin from 'html-webpack-plugin'
import * as webpack from 'webpack'
import * as path from 'path'

const config:webpack.Configuration = {
    entry: ['webpack-hot-middleware/client', './src/index.tsx'],
    output: {
        filename: '[name].bundle.js',
        path: path.resolve(__dirname, 'dist'),
    },
    mode: "development",
    devtool: "source-map",
    resolve: {
        // modules: ["src", "node_modules"],
        extensions: [".ts", ".tsx", ".js"]
    },
    module: {
        rules: [
            {
                test: /\.ts(x?)$/,
                exclude: /node_modules/,
                use: [
                    {
                        loader: "ts-loader"
                    }
                ]
            },
            {
                enforce: "pre",
                test: /\.ts(x?)$/,
                loader: "source-map-loader"
            }
        ]
    },
    externals: {
        'react': 'React',
        "react-dom": "ReactDOM"
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: './index.html'
        }),
        new webpack.HotModuleReplacementPlugin(),
    ]
}

export default config
