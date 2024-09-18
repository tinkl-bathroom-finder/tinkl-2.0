import { useEffect, useState } from "react"
import { useDispatch, useSelector } from "react-redux";
import axios from "axios";

//Types
import { TinklRootState } from "./redux/types/TinklRootState";
import { BathroomType } from "./redux/types/BathroomType";

//Redux Actions
import { setAllBathroomData } from "./redux/reducers/bathroomReducer";
import { setUser, setUserLocation } from "./redux/reducers/userReducer";
import { showMainApp, toggleAboutScreen, toggleDetailsScreen } from "./redux/reducers/tinklOptionsReducer";

//MUI
import { Dialog, DialogContent } from "@mui/material";

//Components
import { UserMenu } from "./components/UserMenu";
import { LoginScreen } from "./components/LoginScreen";
import { ResetPassword } from "./components/ResetPassword";
import { BottomNav } from "./components/BottomNav";
import { LeafletMap } from "./components/LeafletMap";
import { MapLibreMap } from "./components/MapLibreMap";
import { ListView } from "./components/ListView/ListView";
import { AboutScreen } from "./components/AboutScreen";
import { BathroomDetails } from "./components/BathroomDetails";
// import { MapLibreMap } from "./components/MapLibreMap";

import './App.css';

function App() {

  const user = useSelector((state: TinklRootState) => state.user);
  const options = useSelector((state: TinklRootState) => state.options);
  const [radius, _] = useState(8000);
  const [locationReady, setLocationReady] = useState<boolean>(false);
  const [localISOTime, setLocalISOTime] = useState('');
  const locationURL = window.location.pathname;

  const api = import.meta.env.VITE_API_BASE_URL;
  const dispatch = useDispatch();

  // Function to get the user's local time in ISO 8601 format
  const getLocalISOTime = () => {
    const localDate = new Date();
    const localISOTime = new Date(localDate.getTime() - localDate.getTimezoneOffset() * 60000)
      .toISOString()
      .slice(0, 19); // Removing milliseconds
    return localISOTime;
  };

  // Use useEffect to set the local time when the component mounts
  useEffect(() => {
    const currentLocalISOTime = getLocalISOTime();
    setLocalISOTime(currentLocalISOTime);
  }, []);


  //Checks for logged in user
  useEffect(() => {
    console.log(`${api}/user/authenticate`);
    if (!user.username) {
      axios.get(`${api}/user/authenticate/`, { withCredentials: true })
        .then((response) => {
          console.log('user/authenticate', response.data);
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
          setLocationReady(true);
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
    if (locationReady) {
      axios.get<BathroomType[]>(`${api}/api/getBathroomsByRadius/?latitude=${user.location.lat}&longitude=${user.location.lng}&radius=${radius}&localISOTime=${localISOTime}`)
        .then(response => {
          console.log('bathroom response', typeof response.data)
          dispatch(setAllBathroomData(response.data));
        }).catch(error => {
          console.error('Error retrieving data from db: /getBathroomsByRadius', error);
        })
    } else if (localISOTime) {
      axios.get<BathroomType[]>(`${api}/api/getAllBathrooms/?&localISOTime=${localISOTime}`)
        .then(response => {
          console.log('bathroom response', typeof response.data)
          dispatch(setAllBathroomData(response.data));
        }).catch(error => {
          console.error('Error retrieving data from db: /getAllBathrooms', error);
        })
    } 
  }, [locationReady, localISOTime]);

  const handleShowMainApp = () => {
    dispatch(showMainApp());
  }

  useEffect(() => {
    console.log(locationURL);
  })

  return (<div className="container">
    {options.showLogin !== true &&     
      <div className="headerContainer">
        <img className="icon" src="yellow-logo.png" width={60} />
        <a onClick={handleShowMainApp}>
          <header className="header">tinkl</header>
        </a>
        <UserMenu />
      </div>
      }


      {options.showMainApp &&
        <>
      {options.mapView &&
      
            <LeafletMap />
            // <MapLibreMap />
          }
          {!options.mapView &&
            <ListView />
          }
          {options.showAbout &&
            <Dialog open={options.showAbout} onClose={() => dispatch(toggleAboutScreen())}
              PaperProps={{
                sx: {
                  backgroundColor: 'rgba(0, 0, 0, 0)',
                  boxShadow: 'none',
                },
              }}
            >
              <DialogContent>
                <AboutScreen />
              </DialogContent>
            </Dialog>
          }
                    {options.showDetails &&
            <Dialog open={options.showDetails} onClose={() => dispatch(toggleDetailsScreen())}
              PaperProps={{
                sx: {
                  backgroundColor: 'rgba(0, 0, 0, 0)',
                  boxShadow: 'none',
                },
              }}
            >
              <DialogContent>
               <BathroomDetails bathroom/>
              </DialogContent>
            </Dialog>
          }

          <BottomNav />
        </>
      }

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
