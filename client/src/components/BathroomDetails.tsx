import React from "react";
import { useSelector } from "react-redux";
import { BathroomType } from "../redux/types/BathroomType";
import { TinklRootState } from "../redux/types/TinklRootState";

// Components
import { OpenInMapsButton } from "./LeafletMap/mapFunctions/InfoWindow/OpenInMapsButton";
import { GetDirectionsButton } from "./LeafletMap/mapFunctions/InfoWindow/GetDirectionsButton";
import { IPeedHereButton } from "./LeafletMap/mapFunctions/InfoWindow/IPeedHereButton";
import { BusinessHours } from "./BusinessHours";
import { Comments } from "./Comments";

// MUI imports
import {
  Accordion,
  // AccordionDetails,
  AccordionSummary,
  // Box,
  // Button,
  // Card,
  CardActions,
  // CardContent,
  // CardHeader,
  // Collapse,
  // CardMedia,
  // Divider,
  // Grid,
  IconButton,
  // Tooltip,
  Typography
} from "@mui/material";

// MUI Icons
import {
  AccessibleForwardOutlined,
  BabyChangingStationOutlined,
  // Directions,
  ExpandMore,
  Man4,
  // MoreVert,
  // NearMeOutlined,
  OutlinedFlagOutlined,
  // Place,
  Public,
  // QueryBuilder,
  // ThumbUp,
  // ThumbDown,
  ThumbUpOutlined,
  ThumbDownOutlined,
  TransgenderOutlined
} from "@mui/icons-material";



export const BathroomDetails: React.FC = () => {
  const options = useSelector((state: TinklRootState) => state.options);
  const bathroomData: BathroomType[] = useSelector((state: TinklRootState) => state.bathroomData);
  const selectedBathroom = bathroomData.filter(function (br) { return br.id === options.selectedBathroomID })[0]
  console.log("selectedBathroom", selectedBathroom)

  // formats inserted_at timestamp as readable string
  const stringifyDate = (timestamp: any) => {
    const date = new Date(timestamp);
    const optionsLocal: any = { year: "numeric", month: "short", day: "numeric" };
    const stringifiedDate = date.toLocaleDateString("en-us", optionsLocal);
    return stringifiedDate;
  };

  return (
    <div className="detailsContainer">
      <h1>{selectedBathroom.name}</h1>

      <p>{selectedBathroom.street}, {selectedBathroom.city}, MN</p>
      <div className="likes">
        <p>
          {selectedBathroom.public ? <Public /> : ""}
          {selectedBathroom.unisex ? <TransgenderOutlined /> : ""}
          {selectedBathroom.changing_table ? <BabyChangingStationOutlined /> : ""}
          {selectedBathroom.accessible ? <AccessibleForwardOutlined /> : ""}
          {selectedBathroom.is_single_stall ? <Man4 /> : ""}</p>
        <p>
          <ThumbUpOutlined />{selectedBathroom.upvotes}
          <ThumbDownOutlined />{selectedBathroom.downvotes}</p>
      </div>
      <h3 className="detailsButtons"><OpenInMapsButton address={selectedBathroom.name + selectedBathroom.street} />
        <GetDirectionsButton address={selectedBathroom.name + selectedBathroom.street} /></h3>

      {/* <Divider sx={{ m: '5px 0 5px 0' }} /> */}


      {/* Business hours */}
      <Accordion
        sx={{ backgroundColor: '#ffe6e8', boxShadow: 'none' }} >
        <AccordionSummary
          expandIcon={<ExpandMore />}
          aria-controls="panel1-content"
          id="panel1-header"
          sx={{ padding: 0, margin: 0 }}
        >

          <p className={selectedBathroom.is_open ? "open" : "closed"}>
            {selectedBathroom.is_open ? "Open now" : "Closed"}
          </p>
        </AccordionSummary>
        <BusinessHours bathroom={selectedBathroom} />
      </Accordion>

      <Comments bathroom={selectedBathroom} />


      <p className="updated">  {`Updated ${stringifyDate(selectedBathroom.updated_at)}`}</p>

      {/* <Divider sx={{ m: '5px 0 5px 0' }} /> */}
      <IPeedHereButton
      // id={selectedBathroom.id}
      />

      <CardActions disableSpacing>
        <Typography> Something not look right?</Typography>
        <IconButton
        // onClick={() => clickSomethingNotLookRight()}
        >
          <OutlinedFlagOutlined
            sx={{
              mr: 1,
            }}
          />
        </IconButton>
      </CardActions>
    </div>
  )
}