import axios from 'axios';
const url = 'http://localhost:3000/'
function goToAnotherPage(){
    axios.get(url.concat('page'))
}