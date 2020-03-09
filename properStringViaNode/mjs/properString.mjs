import fs from 'fs';

let [
    executablePath,
    mjsPath,
    ...otherArgv
] = process.argv;

otherArgv = otherArgv.map(arg => {
    const buff = new Buffer(arg, 'base64');
    return buff.toString('utf-8');
});

const [siderDir, str] = otherArgv;

const wordArray = str.toLowerCase().split(' ');
const result = wordArray
    .map(word => {
        const wordChars = Array.from(word);
        wordChars[0] = wordChars[0].toUpperCase();
        return wordChars.join('');
    })
    .join(' ');

console.log(result);
// fs.writeFileSync(`${siderDir}/test.txt`, result);
