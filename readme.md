# Openwall BCrypt

BCrypt hashing for Node.js, using [Openwall BCrypt](https://www.openwall.com/crypt/) compiled to [WebAssembly](https://webassembly.org/).

Entropy when generating salts are provided by [`crypto.randomFillSync` from Node.js](https://nodejs.org/api/crypto.html#cryptorandomfillsyncbuffer-offset-size).

Timing attacks are mitigated by using the constant time comparison function [`crypto.timingSafeEqual` from Node.js](https://nodejs.org/api/crypto.html#cryptotimingsafeequala-b).

## Installation

```sh
npm install --save @cwasm/openwall-bcrypt
```

## Usage

```js
const bcrypt = require('@cwasm/openwall-bcrypt')


// When user signs up
const hash = bcrypt.hashSync('password', 12)


// When user logs in
if (bcrypt.compareSync('password', hash)) {
  // The password was correct
}
```

## API

### `compareSync(password, hash)`

- `password` (`string`, required) - The password to be checked.
- `hash` (`string`, required) - The hash to be checked against.
- returns `boolean` - True if the password matches the hash, false otherwise.

Test a password against a previously computed hash.

### `genSaltSync(rounds)`

- `rounds` (`number`, required) - The number of rounds to use when generating the salt.
- returns `string`

Generate a salt.

### `hashSync(password, rounds)`

- `password` (`string`, required) - The password to hash.
- `rounds` (`number`, required) - The number of rounds to use when generating the salt.
- returns `string`

Generate a hash for the given password, using a random salt.
