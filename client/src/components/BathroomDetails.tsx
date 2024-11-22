import React, { useEffect } from "react";
import { useSelector } from "react-redux";

// Components
import { OpenInMapsButton } from "./LeafletMap/MapInfoWindow/OpenInMapsButton";
import { GetDirectionsButton } from "./LeafletMap/MapInfoWindow/GetDirectionsButton";
import { IPeedHereButton } from "./LeafletMap/MapInfoWindow/IPeedHereButton";
import { BusinessHours } from "./BusinessHours";
import { Comments } from "./Comments";

//Functions
import { stringifyDate } from "../modules/stringifyDate";

// MUI Icons
import {
  AccessibleForwardOutlined,
  BabyChangingStationOutlined,
  Man4,
  Public,
  ThumbUpOutlined,
  ThumbDownOutlined,
  TransgenderOutlined,
  Close,
  FavoriteBorderOutlined
} from "@mui/icons-material";

//Modules
import { openInMaps } from "../modules/openInMaps";

//Types
import { TinklRootState } from "../redux/types/TinklRootState";
import { BathroomType } from "../redux/types/BathroomType";


export const BathroomDetails: React.FC = () => {
  const options = useSelector((state: TinklRootState) => state.options);
  const bathroomData: BathroomType[] = useSelector((state: TinklRootState) => state.bathroomData);
  const selectedBathroom = bathroomData.filter(function (br) { return br.id === options.selectedBathroomID })[0]

  const handleClose = () => {
    console.log('close button');
  }

  useEffect(() => {
    console.log(selectedBathroom.day_0_close);
  })


  return (
    <div
      style={{
        position: 'relative',
        left: '7%',
        top: '10%',
        width: '85%',
        height: '75%',
        border: '1px solid black',
        background: 'white',
      }}
    >
      <div
        onClick={handleClose}
        style={{ position: 'relative' }}>
        <Close
          sx={{
            position: 'absolute',
            top: '-10px',
            right: '-7px',
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
      <div
        style={{
          marginLeft: '0.5rem',
          marginTop: '1rem',
        }}
      >
        <div style={{ marginLeft: '0.5rem' }}>
          <p className="updated">  {`Updated ${stringifyDate(selectedBathroom.updated_at)}`}</p>
        </div>

        <div
          style={{
            // display: 'flex',
            marginLeft: '0.5rem',
            marginRight: '1rem',
          }}
        >

          <div
            style={{
              display: 'flex',
              flexDirection: 'row',
              alignItems: 'center',
              justifyContent: 'space-between',
            }}
          >
            <h3>{selectedBathroom.name}</h3>
            <FavoriteBorderOutlined />
          </div>
          <div onClick={() => openInMaps(selectedBathroom.name + selectedBathroom.street)} style={{
            cursor: 'pointer',
            color: 'blue',
            textDecoration: 'underline',
            marginTop: 5,
          }}>
            <h3>{selectedBathroom.street}</h3>
            <h3>{selectedBathroom.city}, {selectedBathroom.state}</h3>
          </div>

          <div
            style={{
              marginTop: '1rem',
              marginBottom: '1rem',
            }}
          >
            {selectedBathroom.public &&
              <div style={{ display: 'flex', alignItems: 'center' }}>
                <Public /><p>Public</p>
              </div>
            }
            {selectedBathroom.unisex &&
              <div style={{ display: 'flex', alignItems: 'center' }}>
                <TransgenderOutlined /><p>Unisex</p>
              </div>
            }
            {selectedBathroom.changing_table &&
              <div style={{ display: 'flex', alignItems: 'center' }}>
                <BabyChangingStationOutlined /><p>Changing Table</p>
              </div>
            }
            {selectedBathroom.accessible &&
              <div style={{ display: 'flex', alignItems: 'center' }}>
                <AccessibleForwardOutlined /><p>Accessible</p>
              </div>
            }
            {selectedBathroom.is_single_stall &&
              <div style={{ display: 'flex', alignItems: 'center' }}>
                <Man4 /><p>Single Stall</p>
              </div>
            }
          </div>
          <div style={{ display: 'flex', flexDirection: 'row', alignItems: 'baseline' }}>
            <div style={{ display: 'flex', paddingRight: '0.5rem' }}>
              <ThumbUpOutlined />
              <p style={{ paddingLeft: '0.2rem' }}>
                {selectedBathroom.upvotes}
              </p>
            </div>
            <div style={{ display: 'flex', paddingRight: '0.5rem' }}>
              <ThumbDownOutlined />
              <p style={{ paddingLeft: '0.2rem' }}>
                {selectedBathroom.downvotes}
              </p>
            </div>
          </div>
        </div>
        <div style={{
          marginTop: '1rem',
          marginLeft: '0.5rem',
        }}>
          <div
            style={{
              color: selectedBathroom.is_open ? 'green' : 'red',
              paddingBottom: '0.5rem',
            }}
          >
            <h4
              className={selectedBathroom.is_open ? "open" : "closed"}

            >{selectedBathroom.is_open ? "Open now" : "Closed"}</h4>
          </div>
          <BusinessHours bathroom={selectedBathroom} />
        </div>
        <div>
          <Comments bathroom={selectedBathroom} />
        </div>

      </div>





    </div >
  );


  // <div className="detailsContainer">
  //   <h1>{selectedBathroom.name}</h1>

  //   <p>{selectedBathroom.street}, {selectedBathroom.city}, MN</p>
  //   <div className="likes">
  //     <p>
  //       {selectedBathroom.public ? <Public /> : ""}
  //       {selectedBathroom.unisex ? <TransgenderOutlined /> : ""}
  //       {selectedBathroom.changing_table ? <BabyChangingStationOutlined /> : ""}
  //       {selectedBathroom.accessible ? <AccessibleForwardOutlined /> : ""}
  //       {selectedBathroom.is_single_stall ? <Man4 /> : ""}</p>
  //     <p>
  //       <ThumbUpOutlined />{selectedBathroom.upvotes}
  //       <ThumbDownOutlined />{selectedBathroom.downvotes}</p>
  //   </div>
  //   <h3 className="detailsButtons"><OpenInMapsButton address={selectedBathroom.name + selectedBathroom.street} />
  //     <GetDirectionsButton address={selectedBathroom.name + selectedBathroom.street} /></h3>

  //   {/* <Divider sx={{ m: '5px 0 5px 0' }} /> */}


  //   {/* Business hours */}
  //   <Accordion
  //     sx={{ backgroundColor: '#ffe6e8', boxShadow: 'none' }} >
  //     <AccordionSummary
  //       expandIcon={<ExpandMore />}
  //       aria-controls="panel1-content"
  //       id="panel1-header"
  //       sx={{ padding: 0, margin: 0 }}
  //     >

  //       <p className={selectedBathroom.is_open ? "open" : "closed"}>
  //         {selectedBathroom.is_open ? "Open now" : "Closed"}
  //       </p>
  //     </AccordionSummary>
  //     <BusinessHours bathroom={selectedBathroom} />
  //   </Accordion>

  //   <Comments bathroom={selectedBathroom} />



  //   {/* <Divider sx={{ m: '5px 0 5px 0' }} /> */}
  //   <IPeedHereButton
  //   // id={selectedBathroom.id}
  //   />

  //   <CardActions disableSpacing>
  //     <Typography> Something not look right?</Typography>
  //     <IconButton
  //     // onClick={() => clickSomethingNotLookRight()}
  //     >
  //       <OutlinedFlagOutlined
  //         sx={{
  //           mr: 1,
  //         }}
  //       />
  //     </IconButton>
  //   </CardActions>
  // </div>

}