import { useEffect, useState } from "react"
import axios from "axios";

function App() {
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    axios.get('http://localhost:5001/')
      .then((response) => {
        console.log(response.data);
      }).catch((error) => {
        console.log(error);
      })
  }, [])


  return (
    <div>
      <p></p>
    </div>
  )
}

export default App
