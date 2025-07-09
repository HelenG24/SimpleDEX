# SimpleDEX - Exchange Descentralizado en Solidity

Este proyecto implementa un exchange descentralizado simple (`SimpleDEX`) para intercambiar dos tokens ERC-20 (`TokenA` y `TokenB`) usando el modelo de producto constante (x * y = k), desplegado en la red **Scroll Sepolia**.

---

## Funciones del contrato `SimpleDEX`

### constructor(address _tokenA, address _tokenB)
Inicializa el contrato con las direcciones de los tokens ERC-20 que se van a intercambiar.

---

### addLiquidity(uint256 amountA, uint256 amountB)
Permite agregar liquidez al pool depositando cantidades iguales (en valor) de `TokenA` y `TokenB`. Solo el `owner` puede hacerlo.

---

### removeLiquidity(uint256 amountA, uint256 amountB)
Permite al `owner` retirar una parte o la totalidad de la liquidez del pool.

---

### swapAforB(uint256 amountAIn)
Permite a cualquier usuario intercambiar `TokenA` por `TokenB` utilizando el pool de liquidez. El precio se calcula dinámicamente con la fórmula del producto constante.

---

### swapBforA(uint256 amountBIn)
Permite a cualquier usuario intercambiar `TokenB` por `TokenA`. También se aplica la fórmula (x * y = k) para determinar el precio.

---

### getPrice(address _token)
Devuelve el precio estimado de 1 unidad del token solicitado (TokenA o TokenB), expresado en el otro token del par.

---

## Direcciones de los contratos desplegados

- **TokenA:** `0x7263F5DC33BfDD3B41C13774a4Aa04643203DF34`
- **TokenB:** `0x73e8C514903074852dE9195AEB0Fc6ceD0B1670A`
- **SimpleDEX:** `0xA306B2E09BAE6D9a9EE200597b53Dc76F037FcE8`

---
