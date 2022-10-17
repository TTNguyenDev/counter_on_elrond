PEM_FILE="../../../wallet/wallet-owner.pem"
COUNTER_CONTRACT="output/counter.wasm"

PROXY_ARGUMENT="--proxy=https://devnet-api.elrond.com"
CHAIN_ARGUMENT="--chain=D"


build_counter() {
    (set -x; erdpy --verbose contract build "$COUNTER_CONTRACT")
}

deploy_counter() {
    erdpy --verbose contract deploy --recall-nonce --project="../counter/" \
          --metadata-payable \
          --pem=${PEM_FILE} \
          --gas-limit=150000000 \
          --proxy=${PROXY} --chain=${CHAIN_ID} \
          --outfile="deploy-testnet.interaction.json" --send --wait-result
    
    ADDRESS=$(erdpy data parse --file="deploy-testnet.interaction.json" --expression="data['emitted_tx']['address']")

    erdpy data store --key=faucet-address --value=${ADDRESS}

    echo ""
    echo "Faucet Smart contract address: ${ADDRESS}"
}

number_to_u64() {
    local NUMBER=$1
    printf "%016x" $NUMBER
}
