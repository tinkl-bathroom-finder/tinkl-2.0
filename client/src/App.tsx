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
import { LeafletMap } from "./components/LeafletMap/LeafletMap";
import { ListView } from "./components/ListView/ListView";
import { AboutScreen } from "./components/AboutScreen";
import { BathroomDetails } from "./components/BathroomDetails";
import { SearchBar } from "./components/LeafletMap/SearchBar";
import { TinklLogo } from "./components/tinklLogo";

//Modules/Functions
import { getLocalISOTime } from "./modules/getLocalISOTime";

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


  // Use useEffect to set the local time when the component mounts
  useEffect(() => {
    const currentLocalISOTime = getLocalISOTime();
    setLocalISOTime(currentLocalISOTime);
  }, []);

  // Checks for logged in user
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
      console.error('Geolocation is not supported by this browser');
    }
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
    } else if (!locationReady) {
      axios.get<BathroomType[]>(`${api}/api/getAllBathrooms/?&localISOTime=${localISOTime}`)
        .then(response => {
          console.log('bathroom response', typeof response.data)
          dispatch(setAllBathroomData(response.data));
        }).catch(error => {
          console.error('Error retrieving data from db: /getAllBathrooms', error);
        })
    }
  }, [locationReady]);

  const handleShowMainApp = () => {
    dispatch(showMainApp());
  }

  return (

    <div className="container">
      {/* <button onClick={testServer}>Test</button> */}

      {options.showLogin !== true &&
        <div className="headerContainer">
          <TinklLogo width={90} height={90} />
          <a onClick={handleShowMainApp}>
            <header className="header">tinkl</header>
          </a>
          <UserMenu />
        </div>
      }


      {options.showMainApp &&
        <>
          {options.mapView &&
            <>
              <SearchBar />
              <LeafletMap />
            </>
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
                <BathroomDetails />
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
