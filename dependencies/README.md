# dependencies
Working with 3rd party canisters


https://internetcomputer.org/docs/current/tutorials/developer-journey/level-2/2.3-third-party-canisters

If you want to start working on your project right away, you might want to try the following commands:

```bash
cd dependencies/
dfx help
dfx canister --help
```

## Running the project locally

If you want to test your project locally, you can use the following commands:

```bash
# Starts the replica, running in the background
dfx start --background

# Deploys your canisters to the replica and generates your candid interface
dfx deploy
```

```bash
# Pull dependencies
dfx deps pull 

# init dependencies 
dfx deps init

# deploy dependencies 
dfx deps deploy

dfx deploy
```

