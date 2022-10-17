PEM_FILE="../../../wallet/wallet-owner.pem"
COUNTER_CONTRACT="output/counter.wasm"

PROXY="https://devnet-gateway.elrond.com"
CHAIN="D"


build_counter() {
    (set -x; erdpy --verbose contract build "$COUNTER_CONTRACT")
}

deploy_counter() {
    erdpy --verbose contract deploy --recall-nonce --project="../counter/" \
          --metadata-payable \
          --pem=${PEM_FILE} \
          --gas-limit=150000000 \
          --proxy=${PROXY} --chain=${CHAIN} \
          --outfile="deploy-testnet.interaction.json" --send --wait-result
    
    ADDRESS=$(erdpy data parse --file="deploy-testnet.interaction.json" --expression="data['emitted_tx']['address']")

    erdpy data store --key=faucet-address --value=${ADDRESS}

    echo ""
    echo "Faucet Smart contract address: ${ADDRESS}"
}

COUNTER_ADDRESS="erd1qqqqqqqqqqqqqpgq5ktw90nxeptv6nnqs5wysuc7tvqnux2ldynsrd70yk"

increment() {
    erdpy --verbose contract call ${COUNTER_ADDRESS} --recall-nonce \
          --pem=${PEM_FILE} \
          --gas-limit=200000000 \
          --proxy=${PROXY} --chain=${CHAIN} \
          --function=increment \
          --send || return
}

get_value() {
    erdpy --verbose contract query ${COUNTER_ADDRESS} \
        --proxy=${PROXY} \
        --function=getValue || return
}
