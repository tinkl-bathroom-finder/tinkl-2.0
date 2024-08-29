import { useEffect } from "react"
import { useDispatch, useSelector } from "react-redux";
import axios from "axios";

//Types
import { TinklRootState } from "./redux/types/TinklRootState";
// import { BathroomType } from "./redux/types/BathroomType";

//Redux Actions
import { setAllBathroomData } from "./redux/reducers/bathroomReducer";
import { setUser } from "./redux/reducers/userReducer";

//Components
import { UserMenu } from "./components/UserMenu";
import { LoginScreen } from "./components/LoginScreen";



import './App.css';

function App() {

  const user = useSelector((state: TinklRootState) => state.user);
  const options = useSelector((state: TinklRootState) => state.options);

  const api = import.meta.env.VITE_API_BASE_URL;
  const dispatch = useDispatch();

  // //Checks for logged in user
  // useEffect(() => {
  //   if (!user.username) {
  //     axios.get('/api/user').then((response) => {
  //       dispatch(setUser(response.data));
  //     }).catch((error) => {
  //       console.log('Error Fetching user from server', error);
  //     });
  //   }
  // }, [user.username]);

  //Test route
  useEffect(() => {
    axios.get(api)
      .then((response) => {
        console.log(response.data);
      }).catch((error) => {
        console.log(error);
      })
  }, []);

  //Makes database call to get bathroom data and puts it into redux
  useEffect(() => {
    console.log(`${api}/api/getAllBathrooms`);
    axios.get(`${api}/api/getAllBathrooms/`)
      .then(response => {
        dispatch(setAllBathroomData(response.data));
      }).catch(error => {
        console.error('Error retrieving data from db', error);
      })
  }, []);

  return (
    <div className="container">
      <div className="headerContainer">
        <header className="header"><img className="icon" src="tinklIcon.png" width={30} />tinkl</header>
        <UserMenu />
      </div>
      {options.showLogin &&
        <LoginScreen />

      }
    </div>
  )
}

export default App
