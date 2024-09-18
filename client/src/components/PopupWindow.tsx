import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { BathroomType } from "../redux/types/BathroomType";
import { Popup } from "react-leaflet";

// Types
import { TinklRootState } from "../redux/types/TinklRootState";

import {
    Avatar,
    Box,
    Button,
    Card,
    CardContent,
    CardHeader,
    Typography,
    CardActions,
    IconButton,
    Grid,
    Paper,
  } from "@mui/material";

  // MUI Icons
import { 
    AccessibleForwardOutlined, 
    BabyChangingStationOutlined, 
    Directions, 
    ExpandMore, 
    Man4, 
    MoreVert, 
    NearMeOutlined, 
    Place,
    Public, 
    QueryBuilder, 
    ThumbUp, 
    ThumbDown, 
    ThumbUpOutlined, 
    ThumbDownOutlined, 
    TransgenderOutlined 
  } from "@mui/icons-material";

// Components
import { OpenInMapsButton } from './OpenInMapsButton';
import { GetDirectionsButton } from "./GetDirectionsButton";

// Actions
import { toggleDetailsScreen } from "../redux/reducers/tinklOptionsReducer";
import { setBathroomID } from "../redux/reducers/tinklOptionsReducer";

import { TimeType } from "../redux/types/UserType";

interface PopupWindowProps {
    bathroom: BathroomType
}

interface TimestampProps {
    timestamp: TimeType
}

interface BathroomDetailsProps {
    bathroom: BathroomType
}

export const PopupWindow: React.FC<PopupWindowProps> = ({bathroom}) => {

    const tinklOptions = useSelector((state: TinklRootState) => state.options);
    const dispatch = useDispatch();

  // formats inserted_at timestamp as readable string
  const stringifyDate = (timestamp) => {
    const date = new Date(timestamp);
    const options = { year: "numeric", month: "short", day: "numeric" };
    const stringifiedDate = date.toLocaleDateString("en-us", options);
    return stringifiedDate;
  };

  const handleShowDetails: React.FC<BathroomDetailsProps> = ({bathroom}) => {
    console.log('bathroom.id: ', bathroom.id)
    dispatch(setBathroomID(bathroom.id))
    dispatch(toggleDetailsScreen());
}

    return(
        <Popup>
        <h1>{bathroom.name}</h1>
        <h2>{bathroom.street}</h2>
        <h2>{bathroom.city}, MN</h2>
        <div className="likes">      
        <p>
          {bathroom.is_public ? <Public /> : ""}
        {bathroom.unisex ? <TransgenderOutlined /> : ""}
        {bathroom.changing_table ? <BabyChangingStationOutlined /> : ""}
        {bathroom.accessible ? <AccessibleForwardOutlined /> : ""}
        {bathroom.is_single_stall ? <Man4 /> : ""}</p>
        <p>
        <ThumbUpOutlined />{bathroom.upvotes}
      <ThumbDownOutlined />{bathroom.downvotes}</p>
      </div>
        <OpenInMapsButton address={bathroom.name + bathroom.street}/>
        <GetDirectionsButton address={bathroom.name + bathroom.street}/>
            <h3 className={bathroom.is_open ? "open" : "closed"}>{bathroom.is_open ? "Open now" : "Closed"}</h3>
        <p className="updated">  {`Updated ${stringifyDate(bathroom.updated_at)}`}</p>
        <Button size="small" variant="contained" onClick={() => handleShowDetails({bathroom})}>Details</Button>
    </Popup>)
}