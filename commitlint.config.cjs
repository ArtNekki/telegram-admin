module.exports = {
    extends: ['@commitlint/config-conventional'],
    rules: {
        'type-enum': [2, 'always', ['feat', 'fix', 'chore', 'docs', 'style', 'refactor', 'test']],
        'type-case': [2, 'always', 'lower-case'],
        'type-empty': [2, 'never'],
        'subject-empty': [2, 'never'],
        'body-leading-blank': [2, 'always'],
        'body-case': [2, 'always', 'sentence-case'],
        'body-max-line-length': [2, 'always', 100],
        'footer-leading-blank': [2, 'always'],
        'header-max-length': [2, 'always', 72]
    }
};
