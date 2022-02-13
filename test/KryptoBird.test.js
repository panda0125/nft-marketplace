const { assert } = require('chai');
const KryptoBird = artifacts.require('./KryptoBird');

// check for chai
require('chai')
.use(require('chai-as-promised'))
.should();

contract('KryptoBird', accounts => {
    let contract;

    before(async () => {
        contract = await KryptoBird.deployed();
    })

    describe('deployment', async () => {
        it('deploys successfully', async () => {
            const address = contract.address;
            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
            assert.notEqual(address, 0x0);
        })
        it('has a name', async () => {
            const name = await contract.name();
            assert.equal(name, 'KryptoBird');
        })
        it('has a symbol', async () => {
            const symbol = await contract.symbol();
            assert.equal(symbol, 'KBIRDZ');
        })
    })

    describe('minting', async () => {
        it('creates a new token', async () => {
            const result = await contract.mint('https...1');
            const totalSupply = await contract.totalSupply();
            const event = result.logs[0].args;

            // Success
            assert.equal(totalSupply, 1);
            assert.equal(event._from, 0x0);
            assert.equal(event._to, accounts[0]);

            // Failure
            await contract.mint('https...1').should.be.rejected;
        })
    })

    describe('indexing', async () => {
        it('creates a list of KryptoBirdz', async () => {
            // Mint 3 new tokens
            await contract.mint('https...2');
            await contract.mint('https...3');
            await contract.mint('https...4');
            const totalSupply = await contract.totalSupply();
            const expected = ['https...1', 'https...2', 'https...3', 'https...4'];
            let result = [];
            for (let i = 0; i < totalSupply; i++) {
                const KryptoBird = await contract.kryptoBirdz(i);
                result.push(KryptoBird);
            }
            assert.equal(result.length, totalSupply);
            assert.equal(result.join(','), expected.join(','));
        })
    })
})