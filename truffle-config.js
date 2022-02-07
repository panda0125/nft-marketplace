module.exports = {

  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 7545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },
  },
  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',

  // Configure your compilers
  compilers: {
    solc: {
      version: "^0.8.11",    // Fetch exact version from solc-bin (default: truffle's version)
      optimizer: {
        enabled: true,
        runs: 200
      },
    }
  },
};
