PC@DESKTOP-3J9VRFO MINGW64 ~/Documents/sui-iap-move-smc
$ sui client call \
  --function update_treasury \
  --module payment \
  --package 0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba \
  --args 0x1568888969ee2c65c267b7342dadba1e87d16cf91ca0661453b8b281ebba1cd0 0x9e7c71a9239cf7e7a1b966e18d0bb10636e41fee590f90946aa5fba62bd76aaa 0x23c0a23da6735eaea651cccd630065e598950842dd65bf7eb948a832b882ea76 \     
  --gas-budget 10000000
[warning] Client/Server api version mismatch, client api version : 1.48.2, server api version : 1.48.1
Transaction Digest: GZeG8xf2jsmwdPN6b1RFDTvK6Z1LVFaLwWmJGCmGZcM3
╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Data                                                                                          
   │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Sender: 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2                                
   │
│ Gas Owner: 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2                             
   │
│ Gas Budget: 10000000 MIST                                                                                 
   │
│ Gas Price: 1000 MIST                                                                                      
   │
│ Gas Payment:                                                                                              
   │
│  ┌──                                                                                                      
   │
│  │ ID: 0x2a4d1f3950575025177be35de66480fe75142e7c483acbbf5cc7182ffb7d6a15                                 
   │
│  │ Version: 349179419                                                                                     
   │
│  │ Digest: EtyP8P5Nd8ULUUDYhQueip2eSDapPkcF395szeQ2QZy1                                                   
   │
│  └──                                                                                                      
   │
│                                                                                                           
   │
│ Transaction Kind: Programmable                                                                            
   │
│ ╭──────────────────────────────────────────────────────────────────────────────────────────────────────────╮ │
│ │ Input Objects                                                                                           
 │ │
│ ├──────────────────────────────────────────────────────────────────────────────────────────────────────────┤ │
│ │ 0   Imm/Owned Object ID: 0x1568888969ee2c65c267b7342dadba1e87d16cf91ca0661453b8b281ebba1cd0             
 │ │
│ │ 1   Shared Object    ID: 0x9e7c71a9239cf7e7a1b966e18d0bb10636e41fee590f90946aa5fba62bd76aaa             
 │ │
│ │ 2   Pure Arg: Type: address, Value: "0x23c0a23da6735eaea651cccd630065e598950842dd65bf7eb948a832b882ea76" │ │
│ ╰──────────────────────────────────────────────────────────────────────────────────────────────────────────╯ │
│ ╭──────────────────────────────────────────────────────────────────────────────────╮                      
   │
│ │ Commands                                                                         │                      
   │
│ ├──────────────────────────────────────────────────────────────────────────────────┤                      
   │
│ │ 0  MoveCall:                                                                     │                      
   │
│ │  ┌                                                                               │                      
   │
│ │  │ Function:  update_treasury                                                    │                      
   │
│ │  │ Module:    payment                                                            │                      
   │
│ │  │ Package:   0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba │                      
   │
│ │  │ Arguments:                                                                    │                      
   │
│ │  │   Input  0                                                                    │                      
   │
│ │  │   Input  1                                                                    │                      
   │
│ │  │   Input  2                                                                    │                      
   │
│ │  └                                                                               │                      
   │
│ ╰──────────────────────────────────────────────────────────────────────────────────╯                      
   │
│                                                                                                           
   │
│ Signatures:                                                                                               
   │
│    fuVILE6YTMKExhNiGmRFW7SKXJfs7z8MujkJpsPnKFTqSZqdkFpR2W1z+7xaZYQeHS2xYissMrRp64mYMcsADA==               
   │
│                                                                                                           
   │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭───────────────────────────────────────────────────────────────────────────────────────────────────╮       
│ Transaction Effects                                                                               │       
├───────────────────────────────────────────────────────────────────────────────────────────────────┤       
│ Digest: GZeG8xf2jsmwdPN6b1RFDTvK6Z1LVFaLwWmJGCmGZcM3                                              │       
│ Status: Success                                                                                   │       
│ Executed Epoch: 732                                                                               │       
│ Mutated Objects:                                                                                  │       
│  ┌──                                                                                              │       
│  │ ID: 0x1568888969ee2c65c267b7342dadba1e87d16cf91ca0661453b8b281ebba1cd0                         │       
│  │ Owner: Account Address ( 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2 )  │       
│  │ Version: 349179420                                                                             │       
│  │ Digest: 3dbuYMZmt6aHX3Y4EuooZNec1bJMFiws2U9BdKrP9WrZ                                           │       
│  └──                                                                                              │       
│  ┌──                                                                                              │       
│  │ ID: 0x2a4d1f3950575025177be35de66480fe75142e7c483acbbf5cc7182ffb7d6a15                         │       
│  │ Owner: Account Address ( 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2 )  │       
│  │ Version: 349179420                                                                             │       
│  │ Digest: FJW4sVHVJ5gz2SSYcykz9xDhPK8eR7uc2TiY5ED5fL87                                           │       
│  └──                                                                                              │       
│  ┌──                                                                                              │       
│  │ ID: 0x9e7c71a9239cf7e7a1b966e18d0bb10636e41fee590f90946aa5fba62bd76aaa                         │       
│  │ Owner: Shared( 349179417 )                                                                     │       
│  │ Version: 349179420                                                                             │       
│  │ Digest: H8cePnvKYBFUFvz6LGhb8pETAejLwD9vwAUvkHLHWx9h                                           │       
│  └──                                                                                              │       
│ Shared Objects:                                                                                   │       
│  ┌──                                                                                              │       
│  │ ID: 0x9e7c71a9239cf7e7a1b966e18d0bb10636e41fee590f90946aa5fba62bd76aaa                         │       
│  │ Version: 349179417                                                                             │       
│  │ Digest: 9udEWJy4uGpoKnPeFkh2kDmVVaW4s5DCiAipfbUZGsjo                                           │       
│  └──                                                                                              │       
│ Gas Object:                                                                                       │       
│  ┌──                                                                                              │       
│  │ ID: 0x2a4d1f3950575025177be35de66480fe75142e7c483acbbf5cc7182ffb7d6a15                         │       
│  │ Owner: Account Address ( 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2 )  │       
│  │ Version: 349179420                                                                             │       
│  │ Digest: FJW4sVHVJ5gz2SSYcykz9xDhPK8eR7uc2TiY5ED5fL87                                           │       
│  └──                                                                                              │       
│ Gas Cost Summary:                                                                                 │       
│    Storage Cost: 3845600 MIST                                                                     │       
│    Computation Cost: 1000000 MIST                                                                 │       
│    Storage Rebate: 3807144 MIST                                                                   │       
│    Non-refundable Storage Fee: 38456 MIST                                                         │       
│                                                                                                   │       
│ Transaction Dependencies:                                                                         │       
│    ELyYHf4p7oErJe66si27atJf2NSms8JpmCeSeNdFxrfp                                                   │       
│    EihnRP1LkTGPxwsVZHd7NmzMmUVM4ebykePhCaqhXjtq                                                   │       
╰───────────────────────────────────────────────────────────────────────────────────────────────────╯       
╭────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                  
 │
├────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                      
 │
│  │ EventID: GZeG8xf2jsmwdPN6b1RFDTvK6Z1LVFaLwWmJGCmGZcM3:0                                                
 │
│  │ PackageID: 0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba                          
 │
│  │ Transaction Module: payment                                                                            
 │
│  │ Sender: 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2                             
 │
│  │ EventType: 0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba::payment::TreasuryUpdated │
│  │ ParsedJSON:                                                                                            
 │
│  │   ┌──────────────┬────────────────────────────────────────────────────────────────────┐                
 │
│  │   │ new_treasury │ 0x23c0a23da6735eaea651cccd630065e598950842dd65bf7eb948a832b882ea76 │                
 │
│  │   ├──────────────┼────────────────────────────────────────────────────────────────────┤                
 │
│  │   │ old_treasury │ 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2 │                
 │
│  │   └──────────────┴────────────────────────────────────────────────────────────────────┘                
 │
│  └──                                                                                                      
 │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭───────────────────────────────────────────────────────────────────────────────────────────────────────╮   
│ Object Changes                                                                                        │   
├───────────────────────────────────────────────────────────────────────────────────────────────────────┤   
│ Mutated Objects:                                                                                      │   
│  ┌──                                                                                                  │   
│  │ ObjectID: 0x1568888969ee2c65c267b7342dadba1e87d16cf91ca0661453b8b281ebba1cd0                       │   
│  │ Sender: 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2                         │   
│  │ Owner: Account Address ( 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2 )      │   
│  │ ObjectType: 0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba::payment::AdminCap  │   
│  │ Version: 349179420                                                                                 │   
│  │ Digest: 3dbuYMZmt6aHX3Y4EuooZNec1bJMFiws2U9BdKrP9WrZ                                               │   
│  └──                                                                                                  │   
│  ┌──                                                                                                  │   
│  │ ObjectID: 0x2a4d1f3950575025177be35de66480fe75142e7c483acbbf5cc7182ffb7d6a15                       │   
│  │ Sender: 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2                         │   
│  │ Owner: Account Address ( 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2 )      │   
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                         │   
│  │ Version: 349179420                                                                                 │   
│  │ Digest: FJW4sVHVJ5gz2SSYcykz9xDhPK8eR7uc2TiY5ED5fL87                                               │   
│  └──                                                                                                  │   
│  ┌──                                                                                                  │   
│  │ ObjectID: 0x9e7c71a9239cf7e7a1b966e18d0bb10636e41fee590f90946aa5fba62bd76aaa                       │   
│  │ Sender: 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2                         │   
│  │ Owner: Shared( 349179417 )                                                                         │   
│  │ ObjectType: 0x88640e3410b1feaefa3e6a56e97699b8efbe4cd1f15297632e17c879b0a532ba::payment::Treasury  │   
│  │ Version: 349179420                                                                                 │   
│  │ Digest: H8cePnvKYBFUFvz6LGhb8pETAejLwD9vwAUvkHLHWx9h                                               │   
│  └──                                                                                                  │   
╰───────────────────────────────────────────────────────────────────────────────────────────────────────╯   
╭───────────────────────────────────────────────────────────────────────────────────────────────────╮       
│ Balance Changes                                                                                   │       
├───────────────────────────────────────────────────────────────────────────────────────────────────┤       
│  ┌──                                                                                              │       
│  │ Owner: Account Address ( 0x4bd0dd1ce4ef4170a4e62326be0e764cfd426f3271889681b669603b49139de2 )  │       
│  │ CoinType: 0x2::sui::SUI                                                                        │       
│  │ Amount: -1038456                                                                               │       
│  └──                            