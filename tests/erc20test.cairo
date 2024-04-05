
// use core::debug::PrintTrait;
use starknet::{ContractAddress,  get_caller_address, contract_address_const,  get_contract_address};
use core::option::OptionTrait;
use core::traits::TryInto;
use first_contract::contracts::{ Ierc20TraitDispatcher, Ierc20TraitDispatcherTrait};
use snforge_std::{ declare, ContractClassTrait, start_prank, CheatTarget };

#[test]
fn test_mint(){

       let contract = declare("ERC20");

       let contract_address = contract.deploy(@ArrayTrait::new()).unwrap();
       let dispatcher = Ierc20TraitDispatcher  { contract_address  };
       let recipient: ContractAddress = 0x0334A0b6e8a9f9BE585c7A21C799299B57B3cF87292f3515B1eeAC96ED5DC80d.try_into().unwrap(); 

       let amount = 1000;
       let mint = dispatcher.mint(recipient, amount); 
       assert(dispatcher.balanceOf(recipient) > 0, 'unsuccesful mint');
       assert(dispatcher.get_total_supply() == 1000, 'incorrect total supply');
       println!("{}", dispatcher.balanceOf(recipient));
}
#[test]
fn test_approve(){
       let contract = declare("ERC20");

       let contract_address = contract.deploy(@ArrayTrait::new()).unwrap();
       let dispatcher = Ierc20TraitDispatcher  { contract_address  };
       let recipient: ContractAddress = 0x0334A0b6e8a9f9BE585c7A21C799299B57B3cF87292f3515B1eeAC96ED5DC80d.try_into().unwrap(); 
       let amount = 1000;
       start_prank(CheatTarget::One(contract_address), recipient);
      let result =  dispatcher.approve(contract_address, amount );
       let val = dispatcher.allowance(recipient,contract_address);
       println!("{val}");
       assert(val == 1000, 'allowance doesnt match approval');
}

#[test]
fn testMint(){
        let contract = declare("ERC20");
// starkli account fetch 0x0334A0b6e8a9f9BE585c7A21C799299B57B3cF87292f3515B1eeAC96ED5DC80d https://starknet-sepolia.g.alchemy.com/v2/55tCRQIEOiGhNxqHkUgB_vGa5PMTsCo7 --output account0_account.json

// starkli declare target/dev/first_contract_ERC20.contract_class.json --rpc https://starknet-sepolia.g.alchemy.com/v2/55tCRQIEOiGhNxqHkUgB_vGa5PMTsCo7 --account account0_account.json --keystore account0_keystore.json
// contract address - 0x0607d204f7d98b76e6d0942e900f11c0872150fc180eb39b1b4aeb491c41a241

// starkli deploy 0x042d1bb183913d15a9dadd29aaf78c58c2244c6ae439f7bfb3f582b6e885d48c --rpc https://starknet-sepolia.g.alchemy.com/v2/55tCRQIEOiGhNxqHkUgB_vGa5PMTsCo7 --account account0_account.json --keystore account0_keystore.json

       // if we want to add a constructorparamter we can do sth like this...
       // let mut arrayConstructor = ArrayTrait::new();
       // arrayConstructor.append('param1');
       // arrayConstructor.append('param2');
       // arrayConstructor.append('param2');

       let contract_address = contract.deploy(@ArrayTrait::new()).unwrap();



       let dispatcher = Ierc20TraitDispatcher  { contract_address  };
       let recipient: ContractAddress = 0x0334A0b6e8a9f9BE585c7A21C799299B57B3cF87292f3515B1eeAC96ED5DC80d.try_into().unwrap(); 

       let token_name = dispatcher.get_name();
       let decimal = dispatcher.get_decimal();
       let supply = dispatcher.get_total_supply();
       assert(decimal == 18, 'incorrect decimal');
       assert(token_name == 'Zk masterclass', 'incorrect name');
       assert(supply < 1, 'incorrect supply');
}

#[test]
fn testTransfer(){
       let contract = declare("ERC20");

       let contract_address = contract.deploy(@ArrayTrait::new()).unwrap();
       let dispatcher = Ierc20TraitDispatcher  { contract_address  };
       let recipient: ContractAddress = 0x0334A0b6e8a9f9BE585c7A21C799299B57B3cF87292f3515B1eeAC96ED5DC80d.try_into().unwrap(); 
       let recipient2 : ContractAddress = 0x07ab19dfcc6981ad7beba769a71a2d1cdd52b3d8a1484637bbb79f18a170cd51.try_into().unwrap();
       let amount: u128 = 1000;
       let amount2 = 500;
       start_prank(CheatTarget::One(contract_address), recipient);
       dispatcher.mint(recipient, amount);
       assert(dispatcher.balanceOf(recipient) > 0, 'incorrect');
       assert(dispatcher.balanceOf(recipient) == amount, 'not 1000');
       dispatcher.transfer(recipient2, amount2);
       assert(dispatcher.balanceOf(recipient) <  1000, 'incorrect');
       assert(dispatcher.balanceOf(recipient) == 500, 'not 1000');
       assert(dispatcher.balanceOf(recipient2) > 0, 'incorrect');
       assert(dispatcher.balanceOf(recipient2) == amount2, 'not 500');

}
