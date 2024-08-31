import { useEffect } from "react"
import { useDispatch, useSelector } from "react-redux";
import axios from "axios";

//Types
import { TinklRootState } from "./redux/types/TinklRootState";
// import { BathroomType } from "./redux/types/BathroomType";

//Redux Actions
import { setAllBathroomData } from "./redux/reducers/bathroomReducer";
import { setUser, setUserLocation } from "./redux/reducers/userReducer";

//Components
import { UserMenu } from "./components/UserMenu";
import { LoginScreen } from "./components/LoginScreen";
import { ResetPassword } from "./components/ResetPassword";

import './App.css';

function App() {

  const user = useSelector((state: TinklRootState) => state.user);
  const options = useSelector((state: TinklRootState) => state.options);
  const locationURL = window.location.pathname;

  const api = import.meta.env.VITE_API_BASE_URL;
  const dispatch = useDispatch();

  //Checks for logged in user
  useEffect(() => {
    console.log(`${api}/user/authenticate`);
    if (!user.username) {
      axios.get(`${api}/user/authenticate/`, { withCredentials: true })
        .then((response) => {
          console.log('api/authenticate', response.data);
          dispatch(setUser(response.data));
        }).catch((error) => {
          console.log('Error Fetching user from server', error);
        });
    }
  }, []);

  //Gets lat and lng coordinates from user and places it in redux state
  useEffect(() => {
    if (navigator.geolocation) {
      const watcher = navigator.geolocation.watchPosition(
        (position) => {
          dispatch(setUserLocation({ lat: position.coords.latitude, lng: position.coords.longitude }));
        },
        (error) => {
          console.error('Error watching position:', error);
        }
      );

      //Return cleans up the watcher on component unmount
      return () => {
        navigator.geolocation.clearWatch(watcher);
      }
    } else {
      console.error('Golocation is not supported by this browser');
    }
  }, []);

  //Test route
  useEffect(() => {
    axios.get(`${api}/viewCount/`, { withCredentials: true })
      .then((response) => {
        console.log(response.data);
      }).catch((error) => {
        console.log(error);
      })
  }, []);

  //Makes database call to get bathroom data and puts it into redux
  useEffect(() => {
    console.log(`/api/getAllBathrooms`);
    axios.get(`/api/getAllBathrooms/`)
      .then(response => {
        dispatch(setAllBathroomData(response.data));
      }).catch(error => {
        console.error('Error retrieving data from db', error);
      })
  }, []);

  useEffect(() => {
    console.log(locationURL);
  })

  return (
    <div className="container">
      <div className="headerContainer">
        <header className="header"><img className="icon" src="tinklIcon.png" width={30} />tinkl</header>
        <UserMenu />
      </div>
      {locationURL.startsWith('/reset-password') &&
        <ResetPassword />
      }
      {options.showLogin &&
        <LoginScreen />

      }
    </div>
  )
}

export default App
