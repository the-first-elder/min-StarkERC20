use starknet::{ContractAddress,  get_caller_address, contract_address_const};

// crreate interface 
#[starknet::interface]
pub trait Ierc20Trait<TcontractState>{
    fn approve(ref self: TcontractState, spender: ContractAddress, amount: u128)-> bool;
    fn allowance(self: @TcontractState, owner: ContractAddress, spender: ContractAddress) -> u128;
    fn balanceOf(self: @TcontractState, address: ContractAddress)-> u128;
    fn mint(ref self: TcontractState, recipeint: ContractAddress, amount: u128) -> bool;
    fn transfer(ref self: TcontractState, recipeint: ContractAddress, amount: u128)-> bool;
    fn get_name( self: @TcontractState)-> felt252;
    fn get_symbol(self:@TcontractState) -> felt252;
    fn get_total_supply(self: @TcontractState)-> u128;
    fn get_decimal(self: @TcontractState)-> u8;
}

// inititiate contract
#[starknet::contract]
mod ERC20{
    // use first_contract::contract::erc20Trait;
    use starknet::{ContractAddress, get_caller_address, get_contract_address};
    use core::option::OptionTrait;
    use core::traits::TryInto;
    // use cairo_smart_contract::erc20::erc20Traits;

    #[storage]
    struct Storage {
        balances: LegacyMap::<ContractAddress,u128>,
        allowances: LegacyMap::<(ContractAddress, ContractAddress), u128>,
        token_name: felt252,
        symbol : felt252,
        decimal: u8,
        total_supply: u128,
        owner: ContractAddress
    }

    #[event]
    #[derive(Drop,starknet::Event)]
    enum Event{
        Mint: Mint
    }

    #[derive(Drop,starknet::Event)]
    struct Mint{
        #[key]
        user:ContractAddress,
        amount: u128
    }
   #[constructor]
    fn constructor(ref self: ContractState) {
        self.token_name.write('Zk masterclass');
        self.symbol.write('ZKMC');
        self.decimal.write(18);
        self.owner.write(0x0334A0b6e8a9f9BE585c7A21C799299B57B3cF87292f3515B1eeAC96ED5DC80d.try_into().unwrap())
    }

  #[abi(embed_v0)]
  impl ERC20 of super::Ierc20Trait<ContractState>{
       fn approve(ref self: ContractState, spender: ContractAddress, amount: u128)-> bool {
         let caller = get_caller_address();
        self.allowances.write((caller ,spender), amount);
        return true;
       }

    fn allowance(self: @ContractState, owner: ContractAddress, spender: ContractAddress) -> u128 {
        let balance = self.allowances.read((owner, spender));
        balance

    }
    fn balanceOf(self: @ContractState, address: ContractAddress)-> u128 {
            let balances = self.balances.read(address);
            balances
    }
    fn mint(ref self: ContractState, recipeint: ContractAddress, amount: u128) -> bool{
        let prev_total =self.total_supply.read();
        self.total_supply.write(prev_total + amount);
        self.balances.write(recipeint, amount);
        self.emit(Mint{user:recipeint, amount:amount});
        return true;

    }
    fn transfer(ref self: ContractState, recipeint: ContractAddress, amount: u128)-> bool{
        let prev_balance = self.balances.read(get_caller_address());
        assert(prev_balance >= amount, 'insuffient');
        self.balances.write(get_caller_address(), prev_balance - amount);
        self.balances.write(recipeint, self.balances.read(recipeint) + amount);
        return true;
    }
    fn get_name( self: @ContractState)-> felt252{
        return self.token_name.read();
    }
    fn get_symbol(self:@ContractState) -> felt252{
        return self.symbol.read();
    }
    fn get_total_supply(self: @ContractState)-> u128{
        return self.total_supply.read();
    }
    fn get_decimal(self: @ContractState)-> u8{
        return self.decimal.read();
    }
  }

}
