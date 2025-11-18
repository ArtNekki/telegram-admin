import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import prettier from 'eslint-config-prettier';

export default [
	// Global ignores (applies to all files)
	{
		ignores: [
			'node_modules/',
			'.cache/',
			'.tmp/',
			'dist/',
			'build/',
			'public/uploads/',
			'.strapi/',
			'src/admin/**',
			'*.config.*', // ignore tool configs like eslint/prettier/commitlint
			'scripts/**',
			'config/env/**', // environment-specific configs (CommonJS)
			'types/generated/**', // auto-generated types
			'generate-keys.js', // utility scripts
		],
	},

	// Base JS/TS recommendations
	eslint.configs.recommended,

	// TypeScript recommendations (without requiring type-checking)
	...tseslint.configs.recommended,

	// Our TypeScript-specific overrides (only for TS/TSX files)
	{
		files: ['**/*.{ts,tsx}'],
		languageOptions: {
			parser: tseslint.parser,
			parserOptions: {
				project: './tsconfig.json',
				tsconfigRootDir: process.cwd(),
			},
		},
		rules: {
			'no-unused-vars': 'off', // disable base rule in TS files
			'@typescript-eslint/no-unused-vars': ['warn', { argsIgnorePattern: '^_' }],
			// 'eqeqeq': 'error',
			// '@typescript-eslint/explicit-function-return-type': 'warn',
		},
	},

	// Project-wide rule tweaks (both JS and TS)
	{
		rules: {
			'no-console': 'off',
		},
	},

    // Must be last, turn off rules conflicts with Prettier
    prettier,
];
