import { useEffect } from "react"
import { useDispatch, useSelector } from "react-redux";
import axios from "axios";

//Types
import { TinklRootState } from "./redux/types/TinklRootState";

//Redux Actions
import { setAllBathroomData } from "./redux/reducers/bathroomReducer";

import './App.css';
import { BathroomType } from "./redux/types/BathroomType";

function App() {
  const api = import.meta.env.VITE_API_BASE_URL;

  const bathroomData = useSelector((state: TinklRootState) => state.bathroomData);
  const dispatch = useDispatch();

  useEffect(() => {
    axios.get(api)
      .then((response) => {
        console.log(response.data);
      }).catch((error) => {
        console.log(error);
      })
  }, []);

  useEffect(() => {
    console.log(`${api}/api/bathroomsRequest`);
    axios.get(`${api}/api/bathroomsRequest/`)
      .then(response => {
        dispatch(setAllBathroomData(response.data));
      }).catch(error => {
        console.error('Error retrieving data from db', error);
      })
  }, []);

  return (
    <div className="container">
      <header className="header"><img className="icon" src="tinklIcon.png" width={30} />tinkl</header>
    </div>
  )
}

export default App
