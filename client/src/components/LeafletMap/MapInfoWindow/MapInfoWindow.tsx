import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { Popup, useMap } from "react-leaflet";

//Components
import { UpvoteBox } from "./UpvoteBox";

// MUI Icons
import {
  AccessibleForwardOutlined,
  BabyChangingStationOutlined,
  Man4,
  Public,
  TransgenderOutlined,
  Close,
  KeyboardArrowRight,
} from "@mui/icons-material";

// Actions
import { toggleDetailsScreen } from "../../../redux/reducers/tinklOptionsReducer";
import { setBathroomID } from "../../../redux/reducers/tinklOptionsReducer";

//Modules
import { stringifyDate } from "../../../modules/stringifyDate";
import { openInMaps } from "../../../modules/openInMaps";

//Types
import { TinklRootState } from "../../../redux/types/TinklRootState";
import { BathroomType } from "../../../redux/types/BathroomType";

interface MapInfoWindowProps {
  bathroom: BathroomType;
}

export const MapInfoWindow: React.FC<MapInfoWindowProps> = ({ bathroom }) => {

  const user = useSelector((state: TinklRootState) => state.user);
  const dispatch = useDispatch();
  const map = useMap(); //Gets the map reference in order to close the popup

  const handleShowDetails = (bathroom: BathroomType) => {
    dispatch(setBathroomID(bathroom.id))
    dispatch(toggleDetailsScreen());
    map.closePopup();
  }

  const handleClose = () => {
    map.closePopup();
  };

  return (
    <Popup
      autoPanPaddingTopLeft={[5, 50]}
      closeButton={false}
      minWidth={180}
    >
      {/* Creates customized close button */}
      <div
        onClick={handleClose}
        style={{ position: 'relative' }}>
        <Close
          style={{
            position: 'absolute',
            top: '-22px',
            right: '-27px',
            background: 'white',
            color: 'black',
            width: '35px',
            height: '35px',
            cursor: 'pointer',
            borderRadius: 18,
            border: '0.01rem solid black',
          }}
        />
      </div>
      {/* End Custom Closed button */}
      {/* width setting prevents name from being covered by absolute position of close button */}
      <div style={{ width: '95%' }}>
        <h2>{bathroom.name}</h2>
        <h2>{bathroom.id}</h2>

      </div>
      <div onClick={() => openInMaps(bathroom.name + bathroom.street)} style={{
        cursor: 'pointer',
        color: 'blue',
        textDecoration: 'underline',
        marginTop: 5,
      }}>
        <h3>{bathroom.street}</h3>
        <h3>{bathroom.city}, {bathroom.state}</h3>
      </div>
      <div className="stats"
        style={{
          marginTop: 5,
        }}
      >
        <h3 className={bathroom.is_open ? "open" : "closed"}>{bathroom.is_open ? "Open now" : "Closed"}</h3>
      </div>
      <div className="likes">
        <p>
          {bathroom.public ? <Public /> : ""}
          {bathroom.unisex ? <TransgenderOutlined /> : ""}
          {bathroom.changing_table ? <BabyChangingStationOutlined /> : ""}
          {bathroom.accessible ? <AccessibleForwardOutlined /> : ""}
          {bathroom.is_single_stall ? <Man4 /> : ""}
        </p>
        <p>
          {/* Upvote/Downvote Buttons */}
          <UpvoteBox user={user} bathroom={bathroom} />
        </p>
      </div>
      {/* End Upvote/Downvote Buttons */}

      <div>
        <p className="updated">  {`Updated ${stringifyDate(bathroom.updated_at)}`}</p>
      </div>

      <div onClick={() => handleShowDetails(bathroom)}>
        <KeyboardArrowRight
          style={{
            position: 'absolute',
            right: '0px',
            bottom: '0px',
            width: '45px',
            height: '45px',
            cursor: 'pointer',
          }}
        />
      </div>
    </Popup>
  )
}