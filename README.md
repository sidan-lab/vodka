# Vodka

Vodka is a library build for Aiken development. It offers

1. Cocktail - Validating utils in writing on-chain code in aiken
2. Mocktail - Unit test utils for easy building mock value for unit test

## Vodka is pure and simple

For your transaction.

```rs
let Transaction { inputs, outputs, extra_signatories, .. } = context.transaction
```

Locating inputs & outputs:

```rs
when (inputs_at(inputs, target_address), outputs_at(outputs, target_address)) is {
  ([only_input], [only_output]) -> ...
  _ -> False
}
```

Checking signature with:

```rs
key_signed(extra_signatories, key_hash_required)
```

## Taste it before vodka cocktail, mocktail can be mixed, blended and Mesh

Building unit testing in vodka, easily indicating how you should build in [whisky](https://whisky.sidan.io/) and [Mesh](https://meshjs.dev/).

You can taste if your transaction can pass your aiken contract validation:

```rs
# Mock transaction
let mock_tx: Transaction = mocktail_tx()
    ...
    |> required_signer_hash(is_key_provided, mock_pub_key_hex(1))
    |> complete()
```

Then move it to blend a whisky:

```rs
let mut tx = MeshTxBuilder::new_core()
tx.spending_plutus_script_v2()
  ...
  .required_signer_hash(key_hash)
  .complete(None)

```

Or Mesh:

```ts
const txBuilder = new MeshTxBuilder();
await txBuilder
  ...
  .requiredSignerHash(keyHash)
  .complete();
```

You can build

## Start mixing

Simply run

```sh
aiken add sidan-lab/vodka --version 0.0.1-beta
```

or putting the below in you `aiken.toml`

```toml
[[dependencies]]
name = "sidan-lab/vodka"
version = "0.0.1-beta"
source = "github"
```

## Documentation

Please refer to the [hosted documentation](https://sidan-lab.github.io/vodka/).
