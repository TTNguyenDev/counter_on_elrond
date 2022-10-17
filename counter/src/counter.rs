#![no_std]

elrond_wasm::imports!();

#[elrond_wasm::contract]
pub trait Counter {
    #[init]
    fn init(&self) {
        self.count().set(&BigInt::zero());
    }

    // endpoints
    #[endpoint]
    fn increment(&self) {
        let count_val = self.count().get();
        self.count().set(&(count_val + BigInt::from(1)));
    }

    #[endpoint]
    fn decrement(&self) {
        let count_val = self.count().get();
        self.count().set(&(count_val - BigInt::from(1)));
    }

    #[endpoint]
    fn reset(&self) {
        self.count().set(&BigInt::zero());
    }

    // views
    #[view(getValue)]
    fn get_num(self) -> BigInt {
        self.count().get()
    }

    // storage

    #[view(getNum)]
    #[storage_mapper("count")]
    fn count(&self) -> SingleValueMapper<BigInt>;
}
