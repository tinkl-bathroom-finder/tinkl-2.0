import React from "react";
import { useDispatch } from "react-redux";
import { BathroomType } from "../../../redux/types/BathroomType";
import { Popup } from "react-leaflet";

import { Button } from "@mui/material";

// MUI Icons
import {
  AccessibleForwardOutlined,
  BabyChangingStationOutlined,
  Man4,
  Public,
  ThumbUpOutlined,
  ThumbDownOutlined,
  TransgenderOutlined
} from "@mui/icons-material";

// Components
import { OpenInMapsButton } from './OpenInMapsButton';
import { GetDirectionsButton } from "./GetDirectionsButton";

// Actions
import { toggleDetailsScreen } from "../../../redux/reducers/tinklOptionsReducer";
import { setBathroomID } from "../../../redux/reducers/tinklOptionsReducer";


interface MapInfoWindowProps {
  bathroom: BathroomType
}

export const MapInfoWindow: React.FC<MapInfoWindowProps> = ({ bathroom }) => {

  const dispatch = useDispatch();

  // formats inserted_at timestamp as readable string
  const stringifyDate = (timestamp: any) => {
    const date = new Date(timestamp);
    const optionsLocal: any = { year: "numeric", month: "short", day: "numeric" };
    const stringifiedDate = date.toLocaleDateString("en-us", optionsLocal);
    return stringifiedDate;
  };

  const handleShowDetails = (bathroom: BathroomType) => {
    console.log('bathroom.id: ', bathroom.id)
    dispatch(setBathroomID(bathroom.id))
    dispatch(toggleDetailsScreen());
  }

  return (
    <Popup>
      <h1>{bathroom.name}</h1>
      <h2>{bathroom.street}</h2>
      <h2>{bathroom.city}, MN</h2>
      <div className="likes">
        <p>
          {bathroom.public ? <Public /> : ""}
          {bathroom.unisex ? <TransgenderOutlined /> : ""}
          {bathroom.changing_table ? <BabyChangingStationOutlined /> : ""}
          {bathroom.accessible ? <AccessibleForwardOutlined /> : ""}
          {bathroom.is_single_stall ? <Man4 /> : ""}</p>
        <p>
          <ThumbUpOutlined />{bathroom.upvotes}
          <ThumbDownOutlined />{bathroom.downvotes}</p>
      </div>
      <OpenInMapsButton address={bathroom.name + bathroom.street} />
      <GetDirectionsButton address={bathroom.name + bathroom.street} />
      <h3 className={bathroom.is_open ? "open" : "closed"}>{bathroom.is_open ? "Open now" : "Closed"}</h3>
      <p className="updated">  {`Updated ${stringifyDate(bathroom.updated_at)}`}</p>
      <Button size="small" variant="contained" onClick={() => handleShowDetails(bathroom)}>Details</Button>
    </Popup>)
}