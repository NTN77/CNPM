const citySelect =  document.querySelector("#provinceDropdown")
const districtSelect = document.querySelector("#districtDropdown")
const wardSelect = document.querySelector("#wardDropdown")

const  valuesOfGoodsInput = document.querySelector('#valueOfGoods')
const ship = document.getElementById("shippingFeeInput")
const shipResults = document.getElementById("shippingFeeResult")

const totalAmount = document.getElementById("totalAmountInput")
const totalAmountResults = document.getElementById("totalAmount")
fetch("https://open.oapi.vn/location/provinces?page=0&size=100")
    .then(res => res.json())
    .then(data => {
        data.data.forEach(province => {
            const option = document.createElement("option");
            option.value = province.name;
            option.text = province.name;
            option.setAttribute("data-province-id", province.id); // Lưu id thay vì provinceId
            citySelect.appendChild(option);
        });
    });
citySelect.addEventListener("change", () => {
    const selectedOption = citySelect.options[citySelect.selectedIndex];
    const provinceId = selectedOption.getAttribute("data-province-id");
    districtSelect.innerHTML = "<option value=''>Chọn Huyện / Quận</option>";
    wardSelect.innerHTML = "<option value=''>Chọn Xã / Phường</option>";

    fetch(`https://open.oapi.vn/location/districts/${provinceId}?page=0&size=100`)
        .then(res => res.json())
        .then(data => {
            data.data.forEach(district => {
                const option = document.createElement("option");
                option.value = district.name;
                option.text = district.name;
                option.setAttribute("data-district-id", district.id); // Lưu id thay vì districtId
                districtSelect.appendChild(option);
            });
        });
});
districtSelect.addEventListener("change", () => {
    const selectedOption = districtSelect.options[districtSelect.selectedIndex];
    const districtId = selectedOption.getAttribute("data-district-id"); // Lấy id từ data attribute

    const selectedProvinceOption = citySelect.options[citySelect.selectedIndex];
    const selectedDistrictOption = districtSelect.options[districtSelect.selectedIndex];

    const provinceName = selectedProvinceOption.text
    const districtName = selectedDistrictOption.text
    wardSelect.innerHTML = "<option value=''>Chọn Xã / Phường</option>";

    fetch(`https://open.oapi.vn/location/wards/${districtId}?page=0&size=100`)
        .then(res => res.json())
        .then(data => {
            data.data.forEach(ward => {
                const option = document.createElement("option");
                option.value = ward.name;
                option.text = ward.name;
                option.setAttribute("data-ward-id", ward.id); // Lưu id thay vì wardId
                wardSelect.appendChild(option);
            });
            calculateFeeShip(provinceName, districtName);
        });
});

async  function calculateFeeShip(cityValue, districtValue) {
    const valuesOfGoods = parseInt(valuesOfGoodsInput.value) || 0;
    console.log(cityValue, districtValue)
    if (cityValue && districtValue) {
        try {
            const url = `http://localhost:8080/HandMadeStore/shippingFee?city=${encodeURIComponent(cityValue)}&district=${encodeURIComponent(districtValue)}&value=${valuesOfGoods}`;
            const response = await fetch(url);
            const data = await response.json();

            feeCost = parseInt(data.fee.fee) || 0;

           ship.value = feeCost

            totalAmount.value = valuesOfGoods + feeCost
            console.log("Giá trị hàng hóa:", valuesOfGoods); // Debug
            console.log("Phí ship:", feeCost); // Debug
            console.log("Tổng cộng:", valuesOfGoods + feeCost); // Debug

            // Định dạng thành tiền Việt Nam đồng
            var formattedShippingFee = formatCurrency(feeCost);
            var formattedTotalAmount = formatCurrency(valuesOfGoods + feeCost);

           shipResults.innerText=formattedShippingFee
            totalAmountResults.innerText = formattedTotalAmount
        } catch (error) {
            console.error("Lỗi khi lấy phí:", error);
        }
    }

}